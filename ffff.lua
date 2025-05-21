local component = require("component")
local me = component.me_interface or component.me_controller
local term = require("term")

local function waitForCraftingCompletion(craftTask)
  while true do
    os.sleep(1)
    if not craftTask.isCanceled() and craftTask.isDone() then
      return true
    end
  end
end

local function craftTritium(amount)
  local items = me.getItemsInNetwork()

  local targetItem
  for _, item in ipairs(items) do
    if item.label and string.lower(item.label):find("tritium") then
      targetItem = item
      break
    end
  end

  if not targetItem then
    print("❌ Тритий не найден.")
    return
  end

  local craftables = me.getCraftables({name = targetItem.name})
  if #craftables == 0 then
    print("❌ Нет шаблона для крафта.")
    return
  end

  local craft = craftables[1].request(amount)
  print("⏳ Крафт запущен...")

  if waitForCraftingCompletion(craft) then
    print("✅ Крафт завершён!")
  else
    print("❌ Ошибка крафта.")
  end
end

term.clear()
print("Введите кол-во трития для крафта:")
local count = tonumber(io.read())

if count and count > 0 then
  craftTritium(count)
else
  print("❌ Введено некорректное число.")
end
