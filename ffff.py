import numpy as np
import openmc
import openmc.lib

#-------------------------------------------------------------------------------Materials-------------------------------------------------------------

FLiBe = openmc.Material(name='FLiBe')
FLiBe.set_density('g/cm3', 2.04)
FLiBe.add_element('F', 57.3)
FLiBe.add_element('Li', 28.2, enrichment=5, enrichment_target='Li6')
FLiBe.add_element('Be', 14.5)

Gas = openmc.Material(name='Gas')
Gas.set_density('g/cm3', 1e-100)
Gas.add_element('He', 1)

Carbon = openmc.Material(name='Carbon')
Carbon.set_density('g/cm3', 2.2)
Carbon.add_element('C', 1)

SS316 = openmc.Material(name='SS316')
SS316.set_density('g/cm3', 7.75)
SS316.add_element('Fe', 95)
SS316.add_element('C', 5)

# mats = [Gas, FLiBe, Gas, FLiBe, SS316, FLiBe, Carbon, Carbon, FLiBe, Gas]

materials = openmc.Materials([FLiBe])
#-------------------------------------------------------------------------------CSG-------------------------------------------------------------------

# N = 10
# r = [20, 75, 350-5, 350, 350+2.5, 350+7.5, 350+7.5+15, 350+7.5+30, 350+37.5+5, 400]
# sph = []
# reg = []
# cells = []

sphere = openmc.Sphere(r=100000)
sphere.boundary_type = 'vacuum'

region = -sphere

cells = openmc.Cell(fill=FLiBe, region=-sphere)

# for i in range(N):
#     sphere = openmc.Sphere(r=r[i])
#     sph.append(sphere)    

# sph[N-1].boundary_type = 'vacuum'

# for i in range(N):
#     if i == 0:
#         region = -sph[i]
#     else:
#         region = +sph[i-1] & -sph[i]
#     reg.append(region)

# for i in range(N):
#     cell = openmc.Cell(region=reg[i], fill=mats[i])
#     cells.append(cell)
 
    
geometry = openmc.Geometry([cells])

#-------------------------------------------------------------------------------Settings--------------------------------------------------------------

source = openmc.IndependentSource()
openmc.stats.Point((0, 0, 0))
source.angle = openmc.stats.Isotropic()
source.energy = openmc.stats.Discrete([14.1e6], [1.0])
source.particles = ['neutron']
source.strength = 9.73e20

settings = openmc.Settings()
settings.track_algorithm = 'double_down'
settings.batches = 10
settings.inactive = 0
settings.particles = 1000000
settings.run_mode = 'fixed source'

#-------------------------------------------------------------------------------Tallies--------------------------------------------------------------

# Create Tally to score TBR
tbr_tally = openmc.Tally(name='TBR')
tbr_tally.scores = ['105']
tallies = openmc.Tallies([tbr_tally])

Be_tally = openmc.Tally(name='Neutron Multiplication')
Be_tally.nuclides = ['F19', 'Li6', 'Li7','Be9']
Be_tally.scores = ['16']
tallies.append(Be_tally)

model = openmc.Model()
model.settings = settings
model.geometry = geometry
model.materials = materials
model.tallies = tallies
model.export_to_model_xml()


openmc.run()










