local component = require("component")
local term = require("term")
local event = require("event")
local sides = require("sides")
local me = component.me_controller -- Или me_interface
local computer = require("computer")

local function waitForCraftingCompletion(craftTask)
  while true do
    os.sleep(1)
    if not craftTask.isCanceled() and craftTask.isDone() then
      return true
    end
  end
end

local function craftTrinium(amount)
  local items = me.getItemsInNetwork()

  local tritiumPattern
  for _, item in ipairs(items) do
    if item.label and string.lower(item.label):find("tritium") then
      tritiumPattern = item
      break
    end
  end

  if not tritiumPattern then
    print("❌ Шаблон трития не найден в сети ME.")
    return
  end

  local craft = me.getCraftables({name = tritiumPattern.name})
  if #craft == 0 then
    print("❌ Крафт для " .. tritiumPattern.name .. " не найден.")
    return
  end

  local request = craft[1].request(amount)
  print("✅ Крафт трития запущен. Ожидаем завершения...")

  if waitForCraftingCompletion(request) then
    print("✅ Крафт трития завершен!")
  else
    print("❌ Ошибка при крафте.")
  end
end

-- Главный цикл
term.clear()
print("🔧 Автокрафт трития через ME-сеть")
print("Введите количество трития для крафта: ")
local input = io.read()
local count = tonumber(input)

if count and count > 0 then
  craftTrinium(count)
else
  print("❌ Неверное число.")
end
