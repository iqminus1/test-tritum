local component = require("component")
local event = require("event")
local term = require("term")
local sides = require("sides")

-- Проверяем наличие необходимых компонентов
local me = component.isAvailable("me_controller") and component.me_controller or nil
if not me then
  print("ME контроллер не найден.")
  return
end

-- Название предмета, который хотим крафтить
local itemName = "tritium" -- часть имени предмета, можно уточнить ниже

-- Количество, которое хотим крафтить
local craftAmount = 100

-- Ищем нужный рецепт
local function findCraftable(namePart)
  local craftables = me.getCraftables()
  for _, craftable in ipairs(craftables) do
    local name = craftable.getItemStack().label:lower()
    if name:find(namePart:lower()) then
      return craftable
    end
  end
  return nil
end

-- Запускаем крафт
local function craftTritium()
  local craftable = findCraftable(itemName)
  if not craftable then
    print("Рецепт трития не найден в ME системе.")
    return
  end

  print("Запуск крафта " .. craftAmount .. "x тритий...")
  local craft = craftable.request(craftAmount)
  if not craft then
    print("Ошибка: не удалось запустить крафт.")
    return
  end

  print("Крафт запущен. Ожидание завершения...")

  while not craft.isDone() do
    os.sleep(1)
  end

  print("Крафт завершён.")
end

-- Основной цикл
while true do
  term.clear()
  print("Нажмите Enter, чтобы начать автокрафт трития...")
  io.read()
  craftTritium()
  print("Нажмите любую клавишу для следующего запуска...")
  os.sleep(1)
end
