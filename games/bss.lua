repeat wait(0.1) until game:IsLoaded()

getgenv().Star = "⭐"
getgenv().Danger = "⚠️"
getgenv().ExploitSpecific = "📜"

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/jeqshka/jeq-bss/main/liblary.lua"))()
getgenv().api = loadstring(game:HttpGet("https://raw.githubusercontent.com/jeqshka/jeq-bss/main/jequi.lua"))()
local bssapi = loadstring(game:HttpGet("https://raw.githubusercontent.com/jeqshka/jeq-bss/main/jeqapi.lua"))()

local playerstatsevent = game:GetService("ReplicatedStorage").Events.RetrievePlayerStats
local statstable = playerstatsevent:InvokeServer()
local monsterspawners = game:GetService("Workspace").MonsterSpawners
local rarename
function rtsg() tab = game.ReplicatedStorage.Events.RetrievePlayerStats:InvokeServer() return tab end
function maskequip(mask) local ohString1 = "Equip" local ohTable2 = { ["Mute"] = false, ["Type"] = mask, ["Category"] = "Accessory"} game:GetService("ReplicatedStorage").Events.ItemPackageEvent:InvokeServer(ohString1, ohTable2) end
local lasttouched = nil
local done = true
local hi = false
local Items = require(game:GetService("ReplicatedStorage").EggTypes).GetTypes()
local v1 = require(game.ReplicatedStorage.ClientStatCache):Get();

hives = game.Workspace.Honeycombs:GetChildren() for i = #hives, 1, -1 do  v = game.Workspace.Honeycombs:GetChildren()[i] if v.Owner.Value == nil then game.ReplicatedStorage.Events.ClaimHive:FireServer(v.HiveID.Value) end end

-- Проходит через все дочерние элементы объекта "CoreGui" и удаляет элементы UI (TextLabel),.
for _, v in pairs(game:GetService("CoreGui"):GetDescendants()) do
    if v:IsA("TextLabel") and string.find(v.Text,"BSS JeqScript") then
        v.Parent.Parent:Destroy()
    end
end

-- Глобальная таблица "temptable" для хранения различных параметров и флагов.
getgenv().temptable = {
    version = "1", -- Версия скрипта
    blackfield = "Sunflower Field", -- Название черного поля
    redfields = {}, -- Список красных полей
    bluefields = {}, -- Список синих полей
    whitefields = {}, -- Список белых полей
    shouldiconvertballoonnow = false, -- Флаг, указывающий на необходимость конвертации воздушных шаров
    balloondetected = false, -- Флаг, указывающий на обнаружение воздушных шаров
    puffshroomdetected = false, -- Флаг, указывающий на обнаружение пуффшрумов
    magnitude = 60, -- Магнитуда (число)
    blacklist = { "" }, -- Список элементов в черном списке
    running = false, -- Флаг, указывающий, выполняется ли какой-либо процесс
    configname = "", -- Название конфигурации
    tokenpath = game:GetService("Workspace").Collectibles, -- Путь к объектам "Collectibles"
    started = {
        vicious = false,
        mondo = false,
        windy = false,
        ant = false,
        monsters = false
    }, -- Флаги, указывающие, запущены ли определенные процессы
    detected = {
        vicious = false,
        windy = false
    }, -- Флаги, указывающие, обнаружены ли определенные элементы
    tokensfarm = false, -- Флаг, указывающий, включен ли режим сбора токенов
    converting = false, -- Флаг, указывающий, в процессе ли конвертация
    consideringautoconverting = false, -- Флаг, указывающий, рассматривается ли автоматическая конвертация
    honeystart = 0, -- Начальное количество меда
    grib = nil, -- Объект "grib"
    gribpos = CFrame.new(0, 0, 0), -- Позиция объекта "grib" (CFrame)
    honeycurrent = statstable.Totals.Honey, -- Текущее количество меда
    dead = false, -- Флаг, указывающий, находится ли персонаж в состоянии "мертв"
    float = false, -- Флаг, указывающий, находится ли персонаж в состоянии "парящего"
    pepsigodmode = false, -- Флаг, указывающий, включен ли "God Mode" (режим бессмертия)
    pepsiautodig = false, -- Флаг, указывающий, включен ли "Auto Dig" (автоматический ремонт)
    alpha = false, -- Флаг, указывающий, включен ли "Alpha" режим
    beta = false, -- Флаг, указывающий, включен ли "Beta" режим
    myhiveis = false, -- Флаг, указывающий, находится ли персонаж в собственной соте
    invis = false, -- Флаг, указывающий, находится ли персонаж в "невидимом" режиме
    windy = nil, -- Объект "windy"
    sprouts = {
        detected = false,
        coords = {}
    }, -- Таблица с данными о координатах "sprouts"
    cache = {
        autofarm = false,
        killmondo = false,
        vicious = false,
        windy = false
    }, -- Кэш различных флагов и параметров
    allplanters = {}, -- Пуст
    planters = {
        planter = {},
        cframe = {},
        activeplanters = {
            type = {},
            id = {}
        }
    }, -- Данные о "planters"
    monstertypes = {"Ladybug", "Rhino", "Spider", "Scorpion", "Mantis", "Werewolf"}, -- Список типов монстров

    -- Функция "stopapypa" для определения ближайшего "Soil" объекта
    ["stopapypa"] = function(path, part)
        local Closest
        for i,v in next, path:GetChildren() do
            if v.Name ~= "PlanterBulb" then
                if Closest == nil then
                    Closest = v.Soil
                else
                    if (part.Position - v.Soil.Position).magnitude < (Closest.Position - part.Position).magnitude then
                        Closest = v.Soil
                    end
                end
            end
        end
        return Closest
    end,

    coconuts = {}, -- Список "coconuts"
    crosshairs = {}, -- Список "crosshairs"
    crosshair = false, -- Флаг, указывающий, включен ли режим "crosshair"
    coconut = false, -- Флаг, указывающий, включен ли режим "coconut"
    act = 0, -- Переменная "act"
    act2 = 0, -- Переменная "act2"

    -- Функция "touchedfunction" для обработки касаний объектов
    ['touchedfunction'] = function(v)
        if lasttouched ~= v then
            if v.Parent.Name == "FlowerZones" then
                if v:FindFirstChild("ColorGroup") then
                    if tostring(v.ColorGroup.Value) == "Red" then
                        maskequip("Demon Mask")
                    elseif tostring(v.ColorGroup.Value) == "Blue" then
                        maskequip("Diamond Mask")
                    end
                else
                    maskequip("Gummy Mask")
                end
                lasttouched = v
            end
        end
    end,

    runningfor = 0, -- Время выполнения
    oldtool = rtsg()["EquippedCollector"], -- Старое оружие
    ['gacf'] = function(part, st)
        coordd = CFrame.new(part.Position.X, part.Position.Y+st, part.Position.Z)
        return coordd
    end
}

-- Таблица "planterst" для хранения данных о "planters"
local planterst = {
    plantername = {},
    planterid = {}
}

-- Проверка, находится ли имя игрока в черном списке.
for i, v in next, temptable.blacklist do
    if v == api.nickname then
        game.Players.LocalPlayer:Kick("You're blacklisted! Get clapped!")
    end
end

-- Если значение "honeystart" равно 0, устанавливаем его на текущее количество меда.
if temptable.honeystart == 0 then
    temptable.honeystart = statstable.Totals.Honey
end

-- Вносим изменения в объекты "MonsterSpawners" и "FlowerZones".
for i, v in next, game:GetService("Workspace").MonsterSpawners:GetDescendants() do
    if v.Name == "TimerAttachment" then
        v.Name = "Attachment"
    end
end
for i, v in next, game:GetService("Workspace").MonsterSpawners:GetChildren() do
    if v.Name == "RoseBush" then
        v.Name = "ScorpionBush"
    elseif v.Name == "RoseBush2" then
        v.Name = "ScorpionBush2"
    end
end
for i, v in next, game:GetService("Workspace").FlowerZones:GetChildren() do
    if v:FindFirstChild("ColorGroup") then
        if v:FindFirstChild("ColorGroup").Value == "Red" then
            table.insert(temptable.redfields, v.Name)
        elseif v:FindFirstChild("ColorGroup").Value == "Blue" then
            table.insert(temptable.bluefields, v.Name)
        end
    else
        table.insert(temptable.whitefields, v.Name)
    end
end

-- Создаем таблицы с данными о различных объектах в игре.
local flowertable = {}
for _, z in next, game:GetService("Workspace").Flowers:GetChildren() do
    table.insert(flowertable, z.Position)
end
local masktable = {}
for _, v in next, game:GetService("ReplicatedStorage").Accessories:GetChildren() do
    if string.match(v.Name, "Mask") then
        table.insert(masktable, v.Name)
    end
end
local collectorstable = {}
for _, v in next, getupvalues(require(game:GetService("ReplicatedStorage").Collectors).Exists) do
    for e, r in next, v do
        table.insert(collectorstable, e)
    end
end
local fieldstable = {}
for _, v in next, game:GetService("Workspace").FlowerZones:GetChildren() do
    table.insert(fieldstable, v.Name)
end
local toystable = {}
for _, v in next, game:GetService("Workspace").Toys:GetChildren() do
    table.insert(toystable, v.Name)
end
local spawnerstable = {}
for _, v in next, game:GetService("Workspace").MonsterSpawners:GetChildren() do
    table.insert(spawnerstable, v.Name)
end
local accesoriestable = {}
for _, v in next, game:GetService("ReplicatedStorage").Accessories:GetChildren() do
    if v.Name ~= "UpdateMeter" then
        table.insert(accesoriestable, v.Name)
    end
end

-- Заполняем список всех типов "planters".
for i, v in pairs(getupvalues(require(game:GetService("ReplicatedStorage").PlanterTypes).GetTypes)) do
    for e, z in pairs(v) do
        table.insert(temptable.allplanters, e)
    end
end

-- Создаем список предметов, которые можно пожертвовать в Штриховом святилище ветра.
local donatableItemsTable = {}
for i, v in pairs(Items) do
    if v.DonatableToWindShrine == true then
        table.insert(donatableItemsTable, i)
    end
end

-- Создаем список предметов, которые представляют собой лакомства.
local treatsTable = {}
for i, v in pairs(Items) do
    if v.TreatValue then
        table.insert(treatsTable, i)
    end
end

-- Создаем список различных баффов и их параметров.
local buffTable = {
    ["Blue Extract"]={b=false,DecalID="2495936060"};
    ["Red Extract"]={b=false,DecalID="2495935291"};
    ["Oil"]={b=false,DecalID="2545746569"}; --?
    ["Enzymes"]={b=false,DecalID="2584584968"};
    ["Glue"]={b=false,DecalID="2504978518"};
    ["Glitter"]={b=false,DecalID="2542899798"};
    ["Tropical Drink"]={b=false,DecalID="3835877932"};
}

-- Создаем список доступных масок (кроме "Honey Mask").
local AccessoryTypes = require(game:GetService("ReplicatedStorage").Accessories).GetTypes()
local MasksTable = {}
for i, v in pairs(AccessoryTypes) do
    if string.find(i, "Mask") then
        if i ~= "Honey Mask" then
            table.insert(MasksTable, i)
        end
    end
end

-- Сортировка таблиц
table.sort(fieldstable) -- Сортировка списка полей
table.sort(accesoriestable) -- Сортировка списка аксессуаров
table.sort(toystable) -- Сортировка списка игрушек
table.sort(spawnerstable) -- Сортировка списка спавнеров монстров
table.sort(masktable) -- Сортировка списка масок
table.sort(temptable.allplanters) -- Сортировка списка всех типов "planters"
table.sort(collectorstable) -- Сортировка списка собирателей
table.sort(donatableItemsTable) -- Сортировка списка предметов, которые можно пожертвовать в Штриховом святилище ветра
table.sort(buffTable) -- Сортировка списка баффов
table.sort(MasksTable) -- Сортировка списка доступных масок (кроме "Honey Mask")

-- Создание "float pad" объекта
local floatpad = Instance.new("Part", game:GetService("Workspace"))
floatpad.CanCollide = false
floatpad.Anchored = true
floatpad.Transparency = 1
floatpad.Name = "FloatPad" -- Имя объекта

-- Создание "cococrab" объекта
local cocopad = Instance.new("Part", game:GetService("Workspace"))
cocopad.Name = "Coconut Part" -- Имя объекта
cocopad.Anchored = true
cocopad.Transparency = 1
cocopad.Size = Vector3.new(10, 1, 10)
cocopad.Position = Vector3.new(-307.52117919922, 105.91863250732, 467.86791992188) -- Позиция объекта

-- Создание "antfarm" объекта
local antpart = Instance.new("Part", workspace)
antpart.Name = "Ant Autofarm Part" -- Имя объекта
antpart.Position = Vector3.new(96, 47, 553) -- Позиция объекта
antpart.Anchored = true
antpart.Size = Vector3.new(128, 1, 50)
antpart.Transparency = 1
antpart.CanCollide = false

-- Конфиг

getgenv().jeq = {
    rares = {}, -- Список редких предметов
    priority = {}, -- Список приоритетных задач
    bestfields = { -- Наилучшие поля для сбора ресурсов
        red = "Pepper Patch",
        white = "Coconut Field",
        blue = "Stump Field"
    },
    blacklistedfields = {}, -- Список запрещенных полей
    killerjeq = {}, -- Список враждебных мобов
    bltokens = {}, -- Список запрещенных токенов
    toggles = { -- Флаги и опции скрипта
        farmduped = false, -- Флаг для дублирования ферм
        autofarm = false, -- Флаг для автоматического сбора ресурсов
        farmclosestleaf = false, -- Флаг для сбора ближайших листьев
        farmbubbles = false, -- Флаг для сбора пузырей
        autodig = false, -- Флаг для автоматического копания
        farmrares = false, -- Флаг для сбора редких предметов
        -- Другие флаги и опции
    },
    vars = { -- Переменные и настройки скрипта
        field = "Ant Field", -- Выбранное поле для сбора ресурсов
        convertat = 100, -- Порог для автоматической конвертации
        farmspeed = 60, -- Скорость сбора ресурсов
        prefer = "Tokens", -- Предпочитаемый тип ресурсов
        walkspeed = 70, -- Скорость ходьбы
        jumppower = 70, -- Сила прыжка
        npcprefer = "All Quests", -- Предпочтительные квесты у NPC
        farmtype = "Walk", -- Тип фермы (например, ходьба)
        monstertimer = 3, -- Интервал таймера мобов
        autodigmode = "Normal", -- Режим автоматического копания
        donoItem = "Coconut", -- Тип предмета для донатов
        donoAmount = 25, -- Количество предметов для донатов
        selectedTreat = "Treat", -- Выбранный лакомство
        selectedTreatAmount = 0, -- Количество выбранного лакомства
        autouseMode = "Just Tickets", -- Режим автоматического использования
        autoconvertWaitTime = 10, -- Время ожидания для автоконвертации
        defmask = "Bubble", -- Стандартная маска
        resettimer = 3, -- Время сброса таймера
    },
    dispensesettings = { -- Настройки автодиспенсера
        blub = false, -- Настройка для ...
        straw = false, -- Настройка для ...
        treat = false, -- Настройка для ...
        coconut = false, -- Настройка для ...
        glue = false, -- Настройка для ...
        rj = false, -- Настройка для ...
        white = false, -- Настройка для ...
        red = false, -- Настройка для ...
        blue = false -- Настройка для ...
    }
}

local defaultjeq = jeq

-- Функция для получения игровых статистических данных
function statsget()
    local StatCache = require(game.ReplicatedStorage.ClientStatCache)
    local stats = StatCache:Get()
    return stats
end

-- Функция для фарма ресурсов
function farm(trying)
    if jeq.toggles.loopfarmspeed then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = jeq.vars.farmspeed
    end
    jeq.api.humanoid():MoveTo(trying.Position) 
    repeat
        task.wait()
    until (trying.Position - jeq.api.humanoidrootpart().Position).magnitude <= 4 or not IsToken(trying) or not temptable.running
end

-- Функция для отключения всех функций бота
function disableall()
    if jeq.toggles.autofarm and not temptable.converting then
        temptable.cache.autofarm = true
        jeq.toggles.autofarm = false
    end
    if jeq.toggles.killmondo and not temptable.started.mondo then
        jeq.toggles.killmondo = false
        temptable.cache.killmondo = true
    end
    if jeq.toggles.killvicious and not temptable.started.vicious then
        jeq.toggles.killvicious = false
        temptable.cache.vicious = true
    end
    if jeq.toggles.killwindy and not temptable.started.windy then
        jeq.toggles.killwindy = false
        temptable.cache.windy = true
    end
end

-- Функция для включения всех функций бота
function enableall()
    if temptable.cache.autofarm then
        jeq.toggles.autofarm = true
        temptable.cache.autofarm = false
    end
    if temptable.cache.killmondo then
        jeq.toggles.killmondo = true
        temptable.cache.killmondo = false
    end
    if temptable.cache.vicious then
        jeq.toggles.killvicious = true
        temptable.cache.vicious = false
    end
    if temptable.cache.windy then
        jeq.toggles.killwindy = true
        temptable.cache.windy = false
    end
end

-- Функция для сбора игровых токенов
function gettoken(v3)
    if not v3 then
        v3 = fieldposition
    end
    task.wait()
    for e, r in next, game:GetService("Workspace").Collectibles:GetChildren() do
        itb = false
        if r:FindFirstChildOfClass("Decal") and jeq.toggles.enabletokenblacklisting then
            if api.findvalue(jeq.bltokens, string.split(r:FindFirstChildOfClass("Decal").Texture, 'rbxassetid://')[2]) then
                itb = true
            end
        end
        if tonumber((r.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude) <= temptable.magnitude / 1.4 and not itb and (v3 - r.Position).magnitude <= temptable.magnitude then
            farm(r)
        end
    end
end

-- Функция для создания спринклеров
function makesprinklers()
    local sprinkler = rtsg().EquippedSprinkler
    local e = 1
    if sprinkler == "Basic Sprinkler" or sprinkler == "The Supreme Saturator" then
        e = 1
    elseif sprinkler == "Silver Soakers" then
        e = 2
    elseif sprinkler == "Golden Gushers" then
        e = 3
    elseif sprinkler == "Diamond Drenchers" then
        e = 4
    end
    for i = 1, e do
        local k = api.humanoid().JumpPower
        if e ~= 1 then
            api.humanoid().JumpPower = 70
            api.humanoid().Jump = true
            task.wait(.2)
        end
        game.ReplicatedStorage.Events.PlayerActivesCommand:FireServer({["Name"] = "Sprinkler Builder"})
        if e ~= 1 then
            api.humanoid().JumpPower = k
            task.wait(1)
        end
    end
end

-- Функция для убийства монстров
function killmobs()
    for i, v in pairs(game:GetService("Workspace").MonsterSpawners:GetChildren()) do
        if v:FindFirstChild("Territory") then
            if v.Name ~= "Commando Chick" and v.Name ~= "CoconutCrab" and v.Name ~= "StumpSnail" and v.Name ~= "TunnelBear" and v.Name ~= "King Beetle Cave" and not v.Name:match("CaveMonster") and not v:FindFirstChild("TimerLabel", true).Visible then
                local monsterpart
                if v.Name:match("Werewolf") then
                    monsterpart = game:GetService("Workspace").Territories.WerewolfPlateau.w
                elseif v.Name:match("Mushroom") then
                    monsterpart = game:GetService("Workspace").Territories.MushroomZone.Part
                else
                    monsterpart = v.Territory.Value
                end
                api.humanoidrootpart().CFrame = monsterpart.CFrame
                repeat
                    api.humanoidrootpart().CFrame = monsterpart.CFrame
                    avoidmob()
                    task.wait(1)
                until v:FindFirstChild("TimerLabel", true).Visible
                for i = 1, 4 do
                    gettoken(monsterpart.Position)
                end
            end
        end
    end
end

-- Функция для проверки, является ли объект игровым токеном
function IsToken(token)
    if not token then
        return false
    end
    if not token.Parent then
        return false
    end
    if token then
        if token.Orientation.Z ~= 0 then
            return false
        end
        if token:FindFirstChild("FrontDecal") then
        else
            return false
        end
        if not token.Name == "C" then
            return false
        end
        if not token:IsA("Part") then
            return false
        end
        return true
    else
        return false
    end
end

-- Функция для проверки, существует ли объект
function check(ok)
    if not ok then
        return false
    end
    if not ok.Parent then
        return false
    end
    return true
end

-- Функция для получения информации о посаженных растениях
function getplanters()
    table.clear(planterst.plantername)
    table.clear(planterst.planterid)
    for i, v in pairs(debug.getupvalues(require(game:GetService("ReplicatedStorage").LocalPlanters).LoadPlanter)[4]) do 
        if v.GrowthPercent == 1 and v.IsMine then
            table.insert(planterst.plantername, v.Type)
            table.insert(planterst.planterid, v.ActorID)
        end
    end
end

-- Функция для фарма муравьев
function farmant()
    antpart.CanCollide = true
    temptable.started.ant = true
    anttable = {left = true, right = false}
    temptable.oldtool = rtsg()['EquippedCollector']
    game.ReplicatedStorage.Events.ItemPackageEvent:InvokeServer("Equip", {["Mute"] = true, ["Type"] = "Spark Staff", ["Category"] = "Collector"})
    game.ReplicatedStorage.Events.ToyEvent:FireServer("Ant Challenge")
    jeq.toggles.autodig = true
    acl = CFrame.new(127, 48, 547)
    acr = CFrame.new(65, 48, 534)
    task.wait(1)
    game.ReplicatedStorage.Events.PlayerActivesCommand:FireServer({["Name"] = "Sprinkler Builder"})
    api.humanoidrootpart().CFrame = api.humanoidrootpart().CFrame + Vector3.new(0, 15, 0)
    task.wait(3)
    repeat
        task.wait()
        for i, v in next, game.Workspace.Toys["Ant Challenge"].Obstacles:GetChildren() do
            if v:FindFirstChild("Root") then
                if (v.Root.Position - api.humanoidrootpart().Position).magnitude <= 40 and anttable.left then
                    api.humanoidrootpart().CFrame = acr
                    anttable.left = false
                    anttable.right = true
                    wait(.1)
                elseif (v.Root.Position - api.humanoidrootpart().Position).magnitude <= 40 and anttable.right then
                    api.humanoidrootpart().CFrame = acl
                    anttable.left = true
                    anttable.right = false
                    wait(.1)
                end
            end
        end
    until game:GetService("Workspace").Toys["Ant Challenge"].Busy.Value == false
    task.wait(1)
    game.ReplicatedStorage.Events.ItemPackageEvent:InvokeServer("Equip", {["Mute"] = true, ["Type"] = temptable.oldtool, ["Category"] = "Collector"})
    temptable.started.ant = false
    antpart.CanCollide = false
end

-- Функция для сбора посаженных растений
function collectplanters()
    getplanters()
    for i, v in pairs(planterst.plantername) do
        if api.partwithnamepart(v, game:GetService("Workspace").Planters) and api.partwithnamepart(v, game:GetService("Workspace").Planters):FindFirstChild("Soil") then
            local soil = api.partwithnamepart(v, game:GetService("Workspace").Planters).Soil
            api.humanoidrootpart().CFrame = soil.CFrame
            game:GetService("ReplicatedStorage").Events.PlanterModelCollect:FireServer(planterst.planterid[i])
            task.wait(.5)
            game:GetService("ReplicatedStorage").Events.PlayerActivesCommand:FireServer({["Name"] = v.." Planter"})
            for i = 1, 5 do
                gettoken(soil.Position)
            end
            task.wait(2)
        end
    end
end

-- Функция для получения приоритетных токенов
function getprioritytokens()
    task.wait()
    if temptable.running == false then
        for e, r in next, game:GetService("Workspace").Collectibles:GetChildren() do
            if r:FindFirstChildOfClass("Decal") then
                local aaaaaaaa = string.split(r:FindFirstChildOfClass("Decal").Texture, 'rbxassetid://')[2]
                if aaaaaaaa ~= nil and api.findvalue(jeq.priority, aaaaaaaa) then
                    if r.Name == game.Players.LocalPlayer.Name and not r:FindFirstChild("got it") or tonumber((r.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude) <= temptable.magnitude/1.4 and not r:FindFirstChild("got it") then
                        farm(r)
                        local val = Instance.new("IntValue", r)
                        val.Name = "got it"
                        break
                    end
                end
            end
        end
    end
end

-- Функция для получения ульев с воздушными шарами
function gethiveballoon()
    task.wait()
    local result = false
    for i, hive in next, game:GetService("Workspace").Honeycombs:GetChildren() do
        task.wait()
        if hive:FindFirstChild("Owner") and hive:FindFirstChild("SpawnPos") then
            if tostring(hive.Owner.Value) == game.Players.LocalPlayer.Name then
                for e, balloon in next, game:GetService("Workspace").Balloons.HiveBalloons:GetChildren() do
                    task.wait()
                    if balloon:FindFirstChild("BalloonRoot") then
                        if (balloon.BalloonRoot.Position - hive.SpawnPos.Value.Position).magnitude < 15 then
                            result = true
                            break
                        end
                    end
                end
            end
        end
    end
    return result
end

-- Функция для конвертации меда
function converthoney()
    task.wait(0)
    if temptable.converting then
        if game.Players.LocalPlayer.PlayerGui.ScreenGui.ActivateButton.TextBox.Text ~= "Stop Making Honey" and game.Players.LocalPlayer.PlayerGui.ScreenGui.ActivateButton.BackgroundColor3 ~= Color3.new(201, 39, 28) or (game:GetService("Players").LocalPlayer.SpawnPos.Value.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 13 then
            api.tween(1, game:GetService("Players").LocalPlayer.SpawnPos.Value * CFrame.fromEulerAnglesXYZ(0, 110, 0) + Vector3.new(0, 0, 9))
            task.wait(.9)
            if game.Players.LocalPlayer.PlayerGui.ScreenGui.ActivateButton.TextBox.Text ~= "Stop Making Honey" and game.Players.LocalPlayer.PlayerGui.ScreenGui.ActivateButton.BackgroundColor3 ~= Color3.new(201, 39, 28) or (game:GetService("Players").LocalPlayer.SpawnPos.Value.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 13 then
                game:GetService("ReplicatedStorage").Events.PlayerHiveCommand:FireServer("ToggleHoneyMaking")
            end
            task.wait(.1)
        end
    end
end

-- Функция для поиска ближайшего цветка
function closestleaf()
    for i, v in next, game.Workspace.Flowers:GetChildren() do
        if temptable.running == false and tonumber((v.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude) < temptable.magnitude/1.4 then
            farm(v)
            break
        end
    end
end

-- Функция для поиска пузырьков
function getbubble()
    for i, v in next, game.workspace.Particles:GetChildren() do
        if string.find(v.Name, "Bubble") and temptable.running == false and tonumber((v.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude) < temptable.magnitude/1.4 then
            farm(v)
            break
        end
    end
end

-- Функция для получения шаров
function getballoons()
    for i, v in next, game:GetService("Workspace").Balloons.FieldBalloons:GetChildren() do
        if v:FindFirstChild("BalloonRoot") and v:FindFirstChild("PlayerName") then
            if v:FindFirstChild("PlayerName").Value == game.Players.LocalPlayer.Name then
                if tonumber((v.BalloonRoot.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude) < temptable.magnitude/1.4 then
                    api.walkTo(v.BalloonRoot.Position)
                end
            end
        end
    end
end

-- Функция для поиска цветков
function getflower()
    flowerrrr = flowertable[math.random(#flowertable)]
    if tonumber((flowerrrr - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude) <= temptable.magnitude/1.4 and tonumber((flowerrrr - fieldposition).magnitude) <= temptable.magnitude/1.4 then 
        if temptable.running == false then 
            if jeq.toggles.loopfarmspeed then 
                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = jeq.vars.farmspeed 
            end 
            api.walkTo(flowerrrr) 
        end 
    end
end

-- Функция для поиска облаков
function getcloud()
    for i, v in next, game:GetService("Workspace").Clouds:GetChildren() do
        e = v:FindFirstChild("Plane")
        if e and tonumber((e.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude) < temptable.magnitude/1.4 then
            api.walkTo(e.Position)
        end
    end
end

-- Функция для получения кокосов
function getcoco(v)
    if temptable.coconut then 
        repeat task.wait() 
        until not temptable.coconut 
    end
    temptable.coconut = true
    api.tween(.1, v.CFrame)
    repeat 
        task.wait() 
        api.walkTo(v.Position) 
    until not v.Parent
    task.wait(.1)
    temptable.coconut = false
    table.remove(temptable.coconuts, table.find(temptable.coconuts, v))
end

-- Функция для получения пыльцы
function getfuzzy()
    pcall(function()
        for i, v in next, game.workspace.Particles:GetChildren() do
            if v.Name == "DustBunnyInstance" and temptable.running == false and tonumber((v.Plane.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude) < temptable.magnitude/1.4 then
                if v:FindFirstChild("Plane") then
                    farm(v:FindFirstChild("Plane"))
                    break
                end
            end
        end
    end)
end

-- Функция для получения пламени
function getflame()
    for i, v in next, game:GetService("Workspace").PlayerFlames:GetChildren() do
        if tonumber((v.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude) < temptable.magnitude/1.4 then
            farm(v)
            break
        end
    end
end

-- Функция для получения дубликатов токенов
function getdupe()
    for i, v in next, game:GetService("Workspace").Camera.DupedTokens:GetChildren() do
        if tonumber((v.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude) < 25 then
            if string.find(v.FrontDecal.Texture, "5877939956") or string.find(v.FrontDecal.Texture, "1629547638") then
                v.CFrame = v.CFrame - Vector3.new(0, 5, 0)
                local hash = tostring(math.random(1, 10000))
                v.Name = hash
                repeat 
                    wait(.05)
                    getgenv().temptable.float = true
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
                until game:GetService("Workspace").Camera.DupedTokens:FindFirstChild(hash) == nil
                getgenv().temptable.float = false
                break
            else
                farm(v)
            end
        end
    end
end

-- Функция для избегания монстров
function avoidmob()
    for i, v in next, game:GetService("Workspace").Monsters:GetChildren() do
        if v:FindFirstChild("Head") then
            if (v.Head.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude < 30 and api.humanoid():GetState() ~= Enum.HumanoidStateType.Freefall then
                game.Players.LocalPlayer.Character.Humanoid.Jump = true
            end
        end
    end
end

-- Функция для получения меток-прицелов
function getcrosshairs(v)
    if v.BrickColor ~= BrickColor.new("Lime green") and v.BrickColor ~= BrickColor.new("Flint") then
        if temptable.crosshair then 
            repeat task.wait() 
            until not temptable.crosshair 
        end
        temptable.crosshair = true
        api.walkTo(v.Position)
        repeat 
            task.wait() 
            api.walkTo(v.Position) 
        until not v.Parent or v.BrickColor == BrickColor.new("Forest green")
        task.wait(.1)
        temptable.crosshair = false
        table.remove(temptable.crosshairs, table.find(temptable.crosshairs, v))
    else
        table.remove(temptable.crosshairs, table.find(temptable.crosshairs, v))
    end
end

-- Функция для выполнения квестов
function makequests()
    for i, v in next, game:GetService("Workspace").NPCs:GetChildren() do
        if v.Name ~= "Ant Challenge Info" and v.Name ~= "Bubble Bee Man 2" and v.Name ~= "Wind Shrine" and v.Name ~= "Gummy Bear" then 
            if v:FindFirstChild("Platform") then 
                if v.Platform:FindFirstChild("AlertPos") then 
                    if v.Platform.AlertPos:FindFirstChild("AlertGui") then 
                        if v.Platform.AlertPos.AlertGui:FindFirstChild("ImageLabel") then
                            image = v.Platform.AlertPos.AlertGui.ImageLabel
                            button = game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.ActivateButton.MouseButton1Click
                            if image.ImageTransparency == 0 then
                                if jeq.toggles.tptonpc then
                                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(v.Platform.Position.X, v.Platform.Position.Y + 3, v.Platform.Position.Z)
                                    task.wait(1)
                                else
                                    api.tween(2, CFrame.new(v.Platform.Position.X, v.Platform.Position.Y + 3, v.Platform.Position.Z))
                                    task.wait(3)
                                end
                                for b, z in next, getconnections(button) do
                                    z.Function()
                                end
                                task.wait(8)
                                if image.ImageTransparency == 0 then
                                    for b, z in next, getconnections(button) do
                                        z.Function()
                                    end
                                end
                                task.wait(2)
                            end
                        end     
                    end
                end 
            end 
        end 
    end
end

-- Настройки для выполнения квестов
getgenv().Tvk1 = {true,"💖"}

-- Функция для пожертвования предметов в алтаре
local function donateToShrine(item, qnt)
    print(qnt)
    local s, e = pcall(function()
        game:GetService("ReplicatedStorage").Events.WindShrineDonation:InvokeServer(item, qnt)
        wait(0.5)
        game.ReplicatedStorage.Events.WindShrineTrigger:FireServer()
        
        local UsePlatform = game:GetService("Workspace").NPCs["Wind Shrine"].Stage
        game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = UsePlatform.CFrame + Vector3.new(0,5,0)
        
        for i = 1, 120 do
            wait(0.05)
            for i, v in pairs(game.Workspace.Collectibles:GetChildren()) do
                if (v.Position - UsePlatform.Position).magnitude < 60 and v.CFrame.YVector.Y == 1 then
                    game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
                end
            end
        end
    end)
    if not s then print(e) end
end

-- Функция для проверки, находится ли алтарь в режиме охлаждения
local function isWindshrineOnCooldown()
    local isOnCooldown = false
    local cooldown = 3600 - (require(game.ReplicatedStorage.OsTime)() - (require(game.ReplicatedStorage.StatTools).GetLastCooldownTime(v1, "WindShrine")))
    if cooldown > 0 then isOnCooldown = true end
    return isOnCooldown
end

-- Функция для получения времени, прошедшего с активации игрушки
local function getTimeSinceToyActivation(name)
    return require(game.ReplicatedStorage.OsTime)() - require(game.ReplicatedStorage.ClientStatCache):Get("ToyTimes")[name]
end

-- Функция для получения времени, до окончания перезарядки игрушки
local function getTimeUntilToyAvailable(n)
    return workspace.Toys[n].Cooldown.Value - getTimeSinceToyActivation(n)
end

-- Функция для проверки доступности использования игрушки
local function canToyBeUsed(toy)
    local timeleft = tostring(getTimeUntilToyAvailable(toy))
    local canbeUsed = false
    if string.find(timeleft, "-") then canbeUsed = true end
    return canbeUsed
end

-- Функция для получения списка предметов с их значениями
function GetItemListWithValue()
    local StatCache = require(game.ReplicatedStorage.ClientStatCache)
    local data = StatCache.Get()
    return data.Eggs
end

-- Функция для использования конвертеров и активирующих предметов
local function useConvertors()
    local conv = {"Instant Converter", "Instant Converter B", "Instant Converter C"}
    
    local lastWithoutCooldown = nil
    
    for i, v in pairs(conv) do
        if canToyBeUsed(v) == true then
            lastWithoutCooldown = v
        end
    end
    
    local converted = false
    
    if lastWithoutCooldown ~= nil and (string.find(jeq.vars.autouseMode, "Ticket") or string.find(jeq.vars.autouseMode, "All")) then
        if converted == false then
            game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer(lastWithoutCooldown)
            converted = true
        end
    end
    
    if GetItemListWithValue()["Snowflake"] > 0 and (string.find(jeq.vars.autouseMode, "Snowflake") or string.find(jeq.vars.autouseMode, "All")) then
        game:GetService("ReplicatedStorage").Events.PlayerActivesCommand:FireServer({["Name"] = "Snowflake"})
    end
    
    if GetItemListWithValue()["Coconut"] > 0 and (string.find(jeq.vars.autouseMode, "Coconut") or string.find(jeq.vars.autouseMode, "All")) then
        game:GetService("ReplicatedStorage").Events.PlayerActivesCommand:FireServer({["Name"] = "Coconut"})
    end
    
    if GetItemListWithValue()["Stinger"] > 0 and (string.find(jeq.vars.autouseMode, "Stinger") or string.find(jeq.vars.autouseMode, "All")) then
        game:GetService("ReplicatedStorage").Events.PlayerActivesCommand:FireServer({["Name"] = "Stinger"})
    end
end

-- Функция для извлечения таблицы с баффами
local function fetchBuffTable(stats)
    local stTab = {}
    if game:GetService("Players").LocalPlayer then
        if game:GetService("Players").LocalPlayer.PlayerGui then
            if game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui then
                for i, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui:GetChildren()) do
                    if v.Name == "TileGrid" then
                        for p, l in pairs(v:GetChildren()) do
                            if l:FindFirstChild("BG") then
                                if l:FindFirstChild("BG"):FindFirstChild("Icon") then
                                    local ic = l:FindFirstChild("BG"):FindFirstChild("Icon")
                                    for field, fdata in pairs(stats) do
                                        if fdata["DecalID"] ~= nil then
                                            if string.find(ic.Image, fdata["DecalID"]) then
                                                if ic.Parent:FindFirstChild("Text") then
                                                    if ic.Parent:FindFirstChild("Text").Text == "" then
                                                        stTab[field] = 1
                                                    else
                                                        local thing = ""
                                                        thing = string.gsub(ic.Parent:FindFirstChild("Text").Text, "x", "")
                                                        stTab[field] = tonumber(thing) + 1
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    return stTab
end


local Config = { WindowName = "BSS JeqScript v"..temptable.version.., Color = Color3.fromRGB(164, 84, 255), Keybind = Enum.KeyCode.Semicolon}
local Window = library:CreateWindow(Config, game:GetService("CoreGui"))

local hometab = Window:CreateTab("Главная")
local farmtab = Window:CreateTab("Фермерство")
local combtab = Window:CreateTab("Сражения")
local itemstab = Window:CreateTab("Предметы")
local misctab = Window:CreateTab("Разное")
local setttab = Window:CreateTab("Настройки")

local loadingInfo = hometab:CreateSection("Загрузка")
local loadingFunctions = loadingInfo:CreateLabel("Загрузка функций..")
wait(1)
loadingFunctions:UpdateText("Функции загружены")
local loadingBackend = loadingInfo:CreateLabel("Загрузка бэкэнда..")

loadingBackend:UpdateText("Загрузка Бекенда")
local loadingUI = loadingInfo:CreateLabel("Загрузка интерфейса..")

local information = hometab:CreateSection("Информация")
information:CreateLabel("Добро пожаловать, "..api.nickname.."!")
information:CreateLabel("Версия скрипта: "..temptable.version)
information:CreateLabel("Версия места: "..game.PlaceVersion)
information:CreateLabel(" - Функция, не предназначенная для безопасности")
information:CreateLabel("⚙ - Настроенная функция")
information:CreateLabel("📜 - Может быть специфичной для эксплоитов")
information:CreateLabel("Версия места: "..game.PlaceVersion)
information:CreateLabel("Скрипт от Boxking776 и Schervi")
information:CreateLabel("Изначально создан weuz_ и mrdevl")
local gainedhoneylabel = information:CreateLabel("Полученный мед: 0")
information:CreateButton("Приглашение на Discord", function() setclipboard("https://discord.gg/jjsploit") end)
information:CreateButton("Пожертвование", function() setclipboard("https://www.paypal.com/paypalme/GHubPay") end)
information:CreateToggle("Панель статуса", true, function(bool)
    jeq.toggles.enablestatuspanel = bool
    if bool == false then
        for i,v in pairs(game:GetService("CoreGui"):GetDescendants()) do
            if string.find(v.Name,"Панель мобов") or string.find(v.Name,"Панель утилит") then
                v.Visible = false
            end
        end
    else
        for i,v in pairs(game:GetService("CoreGui"):GetDescendants()) do
            if string.find(v.Name,"Панель мобов") or string.find(v.Name,"Панель утилит") then
                v.Visible = true
            end
        end
    end
end)

local farmo = farmtab:CreateSection("Ферма")
local fielddropdown = farmo:CreateDropdown("Поле", fieldstable, function(String) jeq.vars.field = String end)
fielddropdown:SetOption(fieldstable[1])
convertatslider = farmo:CreateSlider("Конвертировать при", 0, 100, 100, false, function(Value) jeq.vars.convertat = Value end)
local autofarmtoggle = farmo:CreateToggle("Автоферма [⚙]", nil, function(State) jeq.toggles.autofarm = State end)
autofarmtoggle:CreateKeybind("U", function(Key) end)
farmo:CreateToggle("Автокопка", nil, function(State) jeq.toggles.autodig = State end)
farmo:CreateDropdown("Режим автокопки", {"Обычный","Коллектор Стелс"}, function(Option) jeq.vars.autodigmode = Option end)

local contt = farmtab:CreateSection("Инструменты контейнера")
contt:CreateToggle("Не конвертировать пыльцу", nil, function(State) jeq.toggles.disableconversion = State end)
contt:CreateToggle("Автоматическое уменьшение сумок", nil, function(Boole) jeq.toggles.autouseconvertors = Boole end)
contt:CreateDropdown("Режим уменьшения сумок", {"Конвертеры билетов","Только снежинки","Только кокосы","Жалюзи","Снежинки и кокосы","Билеты и снежинки","Билеты и кокосы","Все"}, function(Select) jeq.vars.autouseMode = Select end)
contt:CreateSlider("Время подтверждения уменьшения", 3, 20, 10, false, function(tttttttt) jeq.vars.autoconvertWaitTime = tonumber(tttttttt) end)

farmo:CreateToggle("Авто-спринклер", nil, function(State) jeq.toggles.autosprinkler = State end)
farmo:CreateToggle("Сбор пузырей", nil, function(State) jeq.toggles.farmbubbles = State end)
farmo:CreateToggle("Сбор пламени", nil, function(State) jeq.toggles.farmflame = State end)
farmo:CreateToggle("Сбор кокосов и душей", nil, function(State) jeq.toggles.farmcoco = State end)
farmo:CreateToggle("Сбор точных перекрестков", nil, function(State) jeq.toggles.collectcrosshairs = State end)
farmo:CreateToggle("Сбор пушистых бомб", nil, function(State) jeq.toggles.farmfuzzy = State end)
farmo:CreateToggle("Сбор под воздушными шарами", nil, function(State) jeq.toggles.farmunderballoons = State end)
farmo:CreateToggle("Сбор под облаками", nil, function(State) jeq.toggles.farmclouds = State end)
farmo:CreateToggle("Сбор дубликатов маркеров", nil, function(State) jeq.toggles.farmduped = State end)
farmo:CreateLabel("")
farmo:CreateToggle("Авто-маска меда", nil, function(bool)
    jeq.toggles.honeymaskconv = bool
end)
farmo:CreateDropdown("Маска по умолчанию", MasksTable, function(val)
    jeq.vars.defmask = val
end)


local farmt = farmtab:CreateSection("Фермерство")
farmt:CreateToggle("Автоматический диспенсер [⚙]", nil, function(State) jeq.toggles.autodispense = State end)
farmt:CreateToggle("Автоматические усилители поля [⚙]", nil, function(State) jeq.toggles.autoboosters = State end)
farmt:CreateToggle("Автоматические часы богатства", nil, function(State) jeq.toggles.clock = State end)
farmt:CreateToggle("Автоматические пряничные медведи [B]", nil, function(State) jeq.toggles.collectgingerbreads = State end)
farmt:CreateToggle("Автоматический самовар [B]", nil, function(State) jeq.toggles.autosamovar = State end)
farmt:CreateToggle("Автоматическая снежная машина [B]", nil, function(State) jeq.toggles.autosnowmachines = State end)
farmt:CreateToggle("Автоматические носки [B]", nil, function(State) jeq.toggles.autostockings = State end)
farmt:CreateToggle("Автоматический медовый венок [B]", nil, function(State) jeq.toggles.autowreath = State end)
farmt:CreateToggle("Автосажалки", nil, function(State) jeq.toggles.autoplanters = State end):AddToolTip("Будет пересаживать ваши саженцы после конвертации, если они достигли 100%")
farmt:CreateToggle("Автоматические медовые свечи [B]", nil, function(State) jeq.toggles.autocandles = State end)
farmt:CreateToggle("Автоматический пир Бисмаса [B]", nil, function(State) jeq.toggles.autofeast = State end)
farmt:CreateToggle("Автоматическое искусство крышки Онетта [B]", nil, function(State) jeq.toggles.autoonettart = State end)
farmt:CreateToggle("Автоматические бесплатные пропуска к муравьям", nil, function(State) jeq.toggles.freeantpass = State end)
farmt:CreateToggle("Сбор ростков", nil, function(State) jeq.toggles.farmsprouts = State end)
farmt:CreateToggle("Сбор пуфшрумов", nil, function(State) jeq.toggles.farmpuffshrooms = State end)
farmt:CreateToggle("Сбор снежинок [🛡️] [B]", nil, function(State) jeq.toggles.farmsnowflakes = State end)
farmt:CreateToggle("Телепортация к редким [⚠️]", nil, function(State) jeq.toggles.farmrares = State end)
farmt:CreateToggle("Автоматическое принятие/подтверждение заданий [⚙]", nil, function(State) jeq.toggles.autoquest = State end)
farmt:CreateToggle("Автоматическое выполнение заданий [⚙]", nil, function(State) jeq.toggles.autodoquest = State end)
farmt:CreateToggle("Автоматический медовый шторм", nil, function(State) jeq.toggles.honeystorm = State end)
farmt:CreateLabel(" ")
farmt:CreateToggle("Сброс энергии пчел после X конвертаций",nil,function(bool) jeq.vars.resetbeeenergy = bool end)
farmt:CreateTextBox("Количество конвертаций", "по умолчанию = 3", true, function(Value) jeq.vars.resettimer = tonumber(Value) end)

local mobkill = combtab:CreateSection("Бой")
mobkill:CreateToggle("Тренировка Краба", nil, function(State) if State then api.humanoidrootpart().CFrame = CFrame.new(-307.52117919922, 107.91863250732, 467.86791992188) end end)
mobkill:CreateToggle("Тренировка Улитки", nil, function(State) fd = game.Workspace.FlowerZones['Stump Field'] if State then api.humanoidrootpart().CFrame = CFrame.new(fd.Position.X, fd.Position.Y-6, fd.Position.Z) else api.humanoidrootpart().CFrame = CFrame.new(fd.Position.X, fd.Position.Y+2, fd.Position.Z) end end)
mobkill:CreateToggle("Убивать Мондо", nil, function(State) jeq.toggles.killmondo = State end)
mobkill:CreateToggle("Убивать Злого", nil, function(State) jeq.toggles.killvicious = State end)
mobkill:CreateToggle("Убивать Ветряного", nil, function(State) jeq.toggles.killwindy = State end)
mobkill:CreateToggle("Автоубийство Мобов", nil, function(State) jeq.toggles.autokillmobs = State end):AddToolTip("Убивает мобов после конвертации определенного количества пыльцы")
mobkill:CreateToggle("Избегать Мобов", nil, function(State) jeq.toggles.avoidmobs = State end)
mobkill:CreateToggle("Авто Муравья", nil, function(State) jeq.toggles.autoant = State end):AddToolTip("Вам нужны Спарк-штучки 😋; Идет на испытание муравьев после конвертации пыльцы")
local amks = combtab:CreateSection("Настройки Автоубийства Мобов")
amks:CreateTextBox('Убивать Мобов После x Конвертаций', 'по умолчанию = 3', true, function(Value) jeq.vars.monstertimer = tonumber(Value) end)

local wayp = misctab:CreateSection("Точки маршрута")
wayp:CreateDropdown("Телепорты на Поля", fieldstable, function(Option) game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").FlowerZones:FindFirstChild(Option).CFrame end)
wayp:CreateDropdown("Телепорты к Монстрам", spawnerstable, function(Option) d = game:GetService("Workspace").MonsterSpawners:FindFirstChild(Option) game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(d.Position.X, d.Position.Y+3, d.Position.Z) end)
wayp:CreateDropdown("Телепорты к Игрушкам", toystable, function(Option) d = game:GetService("Workspace").Toys:FindFirstChild(Option).Platform game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(d.Position.X, d.Position.Y+3, d.Position.Z) end)
wayp:CreateButton("Телепортироваться к улью", function() game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Players").LocalPlayer.SpawnPos.Value end)

local useitems = itemstab:CreateSection("Использовать предметы")

useitems:CreateButton("Использовать все баффы [⚠️]",function() for i,v in pairs(buffTable) do  game:GetService("ReplicatedStorage").Events.PlayerActivesCommand:FireServer({["Name"]=i}) end end)
useitems:CreateLabel("")

for i,v in pairs(buffTable) do 
useitems:CreateButton("Использовать "..i,function() game:GetService("ReplicatedStorage").Events.PlayerActivesCommand:FireServer({["Name"]=i}) end) 
useitems:CreateToggle("Авто использование "..i,nil,function(bool)
    buffTable[i].b = bool
end)
end

local miscc = misctab:CreateSection("Разное")
miscc:CreateButton("Полу-бессмертие для Ant Challenge", function() api.tween(1, CFrame.new(93.4228, 32.3983, 553.128)) task.wait(1) game.ReplicatedStorage.Events.ToyEvent:FireServer("Ant Challenge") game.Players.LocalPlayer.Character.HumanoidRootPart.Position = Vector3.new(93.4228, 42.3983, 553.128) task.wait(2) game.Players.LocalPlayer.Character.Humanoid.Name = 1 local l = game.Players.LocalPlayer.Character["1"]:Clone() l.Parent = game.Players.LocalPlayer.Character l.Name = "Humanoid" task.wait() game.Players.LocalPlayer.Character["1"]:Destroy() api.tween(1, CFrame.new(93.4228, 32.3983, 553.128)) task.wait(8) api.tween(1, CFrame.new(93.4228, 32.3983, 553.128)) end)
local wstoggle = miscc:CreateToggle("Скорость ходьбы", nil, function(State) jeq.toggles.loopspeed = State end) wstoggle:CreateKeybind("K", function(Key) end)
local jptoggle = miscc:CreateToggle("Сила прыжка", nil, function(State) jeq.toggles.loopjump = State end) jptoggle:CreateKeybind("L", function(Key) end)
miscc:CreateToggle("Бессмертие", nil, function(State) jeq.toggles.godmode = State if State then bssapi:Godmode(true) else bssapi:Godmode(false) end end)

local misco = misctab:CreateSection("Другое")
misco:CreateDropdown("Одевать аксессуары", accesoriestable, function(Option) local ohString1 = "Equip" local ohTable2 = { ["Mute"] = false, ["Type"] = Option, ["Category"] = "Accessory" } game:GetService("ReplicatedStorage").Events.ItemPackageEvent:InvokeServer(ohString1, ohTable2) end)
misco:CreateDropdown("Одевать маски", masktable, function(Option) local ohString1 = "Equip" local ohTable2 = { ["Mute"] = false, ["Type"] = Option, ["Category"] = "Accessory" } game:GetService("ReplicatedStorage").Events.ItemPackageEvent:InvokeServer(ohString1, ohTable2) end)
misco:CreateDropdown("Одевать коллекторы", collectorstable, function(Option) local ohString1 = "Equip" local ohTable2 = { ["Mute"] = false, ["Type"] = Option, ["Category"] = "Collector" } game:GetService("ReplicatedStorage").Events.ItemPackageEvent:InvokeServer(ohString1, ohTable2) end)
misco:CreateDropdown("Создать амулет", {"Supreme Star Amulet", "Diamond Star Amulet", "Gold Star Amulet","Silver Star Amulet","Bronze Star Amulet","Moon Amulet"}, function(Option) local A_1 = Option.." Generator" local Event = game:GetService("ReplicatedStorage").Events.ToyEvent Event:FireServer(A_1) end)
misco:CreateButton("Экспортировать таблицу статистики [📜]", function() local StatCache = require(game.ReplicatedStorage.ClientStatCache)writefile("Stats_"..api.nickname..".json", StatCache:Encode()) end)

if string.find(string.upper(identifyexecutor()), "SYN") or string.find(string.upper(identifyexecutor()), "SCRIP") then
    local visu = misctab:CreateSection("Визуальные эффекты")
    local alertText = "☢️ Вам следует убраться! ☢️"
    local alertDesign = "Фиолетовый"
    
    local function pushAlert()
        local alerts = require(game:GetService("ReplicatedStorage").AlertBoxes)
        local chat = function(...)
            alerts:Push(...)
        end
        chat(alertText, nil, alertDesign)
    end
    
    visu:CreateButton("Создать кокос",function()
        syn.secure_call(function() 
            require(game.ReplicatedStorage.LocalFX.FallingCoconut)({
                Pos = game.Players.LocalPlayer.Character.Humanoid.RootPart.CFrame.p,
                Dur = 0.6,
                Radius = 16,
                Delay = 1.5,
                Friendly = true
            })
        end, game.Players.LocalPlayer.PlayerScripts.ClientInit)
    end)
    
    visu:CreateButton("Создать агрессивный кокос",function()
        syn.secure_call(function() 
            require(game.ReplicatedStorage.LocalFX.FallingCoconut)({
                Pos = game.Players.LocalPlayer.Character.Humanoid.RootPart.CFrame.p,
                Dur = 0.6,
                Radius = 16,
                Delay = 1.5,
                Friendly = false
            })
        end, game.Players.LocalPlayer.PlayerScripts.ClientInit)
    end)
    
    visu:CreateButton("Создать мифический метеорит",function()
        syn.secure_call(function() 
            require(game.ReplicatedStorage.LocalFX.MythicMeteor)({
                Pos = game.Players.LocalPlayer.Character.Humanoid.RootPart.CFrame.p,
                Dur = 0.6,
                Radius = 16,
                Delay = 1.5,
                Friendly = true
            })
        end, game.Players.LocalPlayer.PlayerScripts.ClientInit)
    end)
    
    visu:CreateButton("Создать мармеладку",function()
        local jellybeans = {"Темно-синяя","Синяя","Спойлер","Меригольд","Бирюзовая","Перевернутая","Розовая","Сланцево-серая","Белая","Черная","Зеленая","Коричневая","Желтая","Марсель","Красная"}
        syn.secure_call(function() 
            require(game.ReplicatedStorage.LocalFX.JellyBeanToss)({
                Start = game.Players.LocalPlayer.Character.Humanoid.RootPart.CFrame.p,
                Type = jellybeans[math.random(1,#jellybeans)],
                End = (game.Players.LocalPlayer.Character.Humanoid.RootPart.CFrame * CFrame.new(0,0,-35)).p + Vector3.new(math.random(1,20),0,math.random(1,20))
            })
        end, game.Players.LocalPlayer.PlayerScripts.ClientInit)
    end)
    
    visu:CreateButton("Создать споры гриба-пушистика",function()
        task.spawn(function() syn.secure_call(function()
            local field = game:GetService("Workspace").FlowerZones:GetChildren()[math.random(1,#game:GetService("Workspace").FlowerZones:GetChildren())]
            local pos = field.CFrame.p
            require(game.ReplicatedStorage.LocalFX.PuffshroomSporeThrow)({
                Start = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.p,
                End = pos,
            })
        end, game.Players.LocalPlayer.PlayerScripts.ClientInit) 
        wait(10)
        workspace.Particles:FindFirstChild("SporeCloud"):Destroy()
        end)
    end)
    
    visu:CreateButton("Создать вечеринку",function()
        syn.secure_call(function() 
            require(game:GetService("ReplicatedStorage").LocalFX.PartyPopper)({
                Pos = game.Players.LocalPlayer.Character.Humanoid.RootPart.CFrame.p,
            })
        end, game.Players.LocalPlayer.PlayerScripts.ClientInit)
    end)
    
    visu:CreateButton("Создать огонь",function()
        syn.secure_call(function()
            require(game.ReplicatedStorage.LocalFX.LocalFlames).AddFlame(
                game.Players.LocalPlayer.Character.Humanoid.RootPart.CFrame.p,
                10,
                1,
                game.Players.LocalPlayer.UserId,
                false
            )
        end, game.Players.LocalPlayer.PlayerScripts.ClientInit)
    end)
    
    visu:CreateButton("Создать темный огонь",function()
        syn.secure_call(function()
            require(game.ReplicatedStorage.LocalFX.LocalFlames).AddFlame(
                game.Players.LocalPlayer.Character.Humanoid.RootPart.CFrame.p,
                10,
                1,
                game.Players.LocalPlayer.UserId,
                true
            )
        end, game.Players.LocalPlayer.PlayerScripts.ClientInit)
    end)
    
    local booolholder = false
    visu:CreateToggle("Ходьба с огнем",nil,function(boool)
        if boool == true then
            booolholder = true
            repeat wait(0.1)
                syn.secure_call(function()
                    require(game.ReplicatedStorage.LocalFX.LocalFlames).AddFlame(
                        game.Players.LocalPlayer.Character.Humanoid.RootPart.CFrame.p,
                        10,
                        1,
                        game.Players.LocalPlayer.UserId,
                        false
                    )
                end, game.Players.LocalPlayer.PlayerScripts.ClientInit)
            until booolholder == false
        else
            booolholder = false
        end
    end)
    
    visu:CreateToggle("Ходьба с темным огнем",nil,function(boool)
        if boool == true then
            booolholder = true
            repeat wait(0.1)
                syn.secure_call(function()
                    require(game.ReplicatedStorage.LocalFX.LocalFlames).AddFlame(
                        game.Players.LocalPlayer.Character.Humanoid.RootPart.CFrame.p,
                        10,
                        1,
                        game.Players.LocalPlayer.UserId,
                        true
                    )
                end, game.Players.LocalPlayer.PlayerScripts.ClientInit)
            until booolholder == false
        else
            booolholder = false
        end
    end)
    
    visu:CreateLabel("")
    
    local styles = {}
    local raw = {
        Синий = Color3.fromRGB(50, 131, 255), 
        ChaChing = Color3.fromRGB(50, 131, 255), 
        Зеленый = Color3.fromRGB(27, 119, 43), 
        Красный = Color3.fromRGB(201, 39, 28), 
        Белый = Color3.fromRGB(140, 140, 140), 
        Желтый = Color3.fromRGB(218, 216, 31), 
        Золотой = Color3.fromRGB(254, 200, 9), 
        Розовый = Color3.fromRGB(242, 129, 255), 
        Бирюзовый = Color3.fromRGB(33, 255, 171), 
        Фиолетовый = Color3.fromRGB(125, 97, 232), 
        Та-Да = Color3.fromRGB(254, 200, 9), 
        Праздничный = Color3.fromRGB(197, 0, 15), 
        Праздничный2 = Color3.fromRGB(197, 0, 15), 
        Значок = Color3.fromRGB(254, 200, 9), 
        Робо = Color3.fromRGB(34, 255, 64), 
        ОхотаЗаЯйцами = Color3.fromRGB(236, 227, 158), 
        Злой = Color3.fromRGB(0, 1, 5), 
        Коричневый = Color3.fromRGB(82, 51, 43)
    }
    local alertDesign2 = "ChaChing"
    for i,v in pairs(raw) do table.insert(styles,i) end
    
    visu:CreateDropdown("Стиль уведомлений",styles,function(dd) 
        alertDesign2 = dd
    end)
    
    visu:CreateTextBox("Текст","например, Привет, мир",false,function(tx)
        alertText = tx
        alertDesign = alertDesign2
        syn.secure_call(pushAlert, game:GetService("Players").LocalPlayer.PlayerScripts.AlertBoxes)
    end)
    
    visu:CreateLabel("")
    
    local destroym = true
    visu:CreateToggle("Уничтожать карту", true, function(State) destroym = State end)
    local nukeDuration = 10
    local nukePosition = Vector3.new(-26.202560424804688, 0.657240390777588, 172.31759643554688)
    local spoof = game:GetService("Players").LocalPlayer.PlayerScripts.AlertBoxes
    
    function Nuke()
        require(game.ReplicatedStorage.LocalFX.MythicMeteor)({
            Pos = nukePosition,
            Dur = nukeDuration,
            Radius = 50,
            Delay = 1
        })
    end
end

function ОблакоПыли()
    require(game.ReplicatedStorage.LocalFX.OrbExplode)({
        Color = Color3.new(0.313726, 0.313726, 0.941176);
        Radius = 600;
        Dur = 15;
        Pos = nukePosition;
    })
end

visu:CreateButton("Спавн Ядерной Бомбы",function() 
    alertText = "☢️ Приближается ядерный удар! ☢️"
    syn.secure_call(pushAlert, spoof)
    alertText = "☢️ Уберитесь куда-нибудь высоко! ☢️"
    wait(1.5)
    task.spawn(function()
        local Humanoid = game.Players.LocalPlayer.Character.Humanoid
        for i = 1, 950 do
            local x = math.random(-100,100)/100
            local y = math.random(-100,100)/100
            local z = math.random(-100,100)/100
            Humanoid.CameraOffset = Vector3.new(x,y,z)
            wait(0.01)
        end
    end)
    syn.secure_call(pushAlert, spoof)
    wait(10)
    spawn(function() syn.secure_call(Nuke, game.Players.LocalPlayer.PlayerScripts.ClientInit) end)
    wait(nukeDuration)
    spawn(function() syn.secure_call(ОблакоПыли, game.Players.LocalPlayer.PlayerScripts.ClientInit) end)
    wait(1)
    local Orb = game:GetService("Workspace").Particles:FindFirstChild("Orb")
    if Orb then Orb.CanCollide = true end
    if destroym == true then
        repeat wait(3)
            for i,v in pairs(Orb:GetTouchingParts()) do
                if v.Anchored == true then v.Anchored = false end 
                v:BreakJoints()
                v.Position = v.Position + Vector3.new(0,0,2)
            end
        until Orb == nil
    end
end)

local autofeed = itemstab:CreateSection("Автоматическое кормление")

local function кормитьВсехПчел(лакомство, количество)
    for L = 1, 5 do
        for U = 1, 10 do
            game:GetService("ReplicatedStorage").Events.ConstructHiveCellFromEgg:InvokeServer(L, U, лакомство, количество)
        end
    end
end

autofeed:CreateDropdown("Выберите лакомство", treatsTable, function(option) jeq.vars.selectedTreat = option end)
autofeed:CreateTextBox("Количество лакомства", "10", false, function(Value) jeq.vars.selectedTreatAmount = tonumber(Value) end)
autofeed:CreateButton("Покормить всех пчел", function() кормитьВсехПчел(jeq.vars.selectedTreat, jeq.vars.selectedTreatAmount) end)

local windShrine = itemstab:CreateSection("Ветряная святыня")
windShrine:CreateDropdown("Выберите предмет", donatableItemsTable, function(Option)  jeq.vars.donoItem = Option end)
windShrine:CreateTextBox("Количество предмета", "10", false, function(Value) jeq.vars.donoAmount = tonumber(Value) end)
windShrine:CreateButton("Пожертвовать", function()
    donateToShrine(jeq.vars.donoItem, jeq.vars.donoAmount)
    print(jeq.vars.donoAmount)
end)
windShrine:CreateToggle("Автоматически пожертвовать", nil, function(selection)
    jeq.toggles.autodonate = selection
end)

local farmsettings = setttab:CreateSection("Настройки автофарма")
farmsettings:CreateTextBox("Скорость ходьбы при автофарме", "Значение по умолчанию = 60", true, function(Value) jeq.vars.farmspeed = Value end)


farmsettings:CreateToggle("^ Скорость в режиме автофарма", nil, function(State) jeq.toggles.loopfarmspeed = State end)
farmsettings:CreateToggle("Не ходить в поле", nil, function(State) jeq.toggles.farmflower = State end)
farmsettings:CreateToggle("Преобразовывать воздушные шары из улья", nil, function(State) jeq.toggles.convertballoons = State end)
farmsettings:CreateToggle("Не собирать токены", nil, function(State) jeq.toggles.donotfarmtokens = State end)
farmsettings:CreateToggle("Включить черный список токенов", nil, function(State) jeq.toggles.enabletokenblacklisting = State end)
farmsettings:CreateSlider("Скорость движения", 0, 120, 70, false, function(Value) jeq.vars.walkspeed = Value end)
farmsettings:CreateSlider("Сила прыжка", 0, 120, 70, false, function(Value) jeq.vars.jumppower = Value end)

local raresettings = setttab:CreateSection("Настройки токенов")
raresettings:CreateTextBox("ID предмета", 'rbxassetid', false, function(Value) rarename = Value end)
raresettings:CreateButton("Добавить токен в список редких предметов", function()
    table.insert(jeq.rares, rarename)
    game:GetService("CoreGui"):FindFirstChild(_G.windowname).Main:FindFirstChild("Список редких предметов D", true):Destroy()
    raresettings:CreateDropdown("Список редких предметов", jeq.rares, function(Option) end)
end)
raresettings:CreateButton("Удалить токен из списка редких предметов", function()
    table.remove(jeq.rares, api.tablefind(jeq.rares, rarename))
    game:GetService("CoreGui"):FindFirstChild(_G.windowname).Main:FindFirstChild("Список редких предметов D", true):Destroy()
    raresettings:CreateDropdown("Список редких предметов", jeq.rares, function(Option) end)
end)
raresettings:CreateButton("Добавить токен в черный список", function()
    table.insert(jeq.bltokens, rarename)
    game:GetService("CoreGui"):FindFirstChild(_G.windowname).Main:FindFirstChild("Черный список токенов D", true):Destroy()
    raresettings:CreateDropdown("Черный список токенов", jeq.bltokens, function(Option) end)
end)
raresettings:CreateButton("Удалить токен из черного списка", function()
    table.remove(jeq.bltokens, api.tablefind(jeq.bltokens, rarename))
    game:GetService("CoreGui"):FindFirstChild(_G.windowname).Main:FindFirstChild("Черный список токенов D", true):Destroy()
    raresettings:CreateDropdown("Черный список токенов", jeq.bltokens, function(Option) end)
end)

raresettings:CreateDropdown("Черный список токенов", jeq.bltokens, function(Option) end)
raresettings:CreateDropdown("Список редких предметов", jeq.rares, function(Option) end)

local dispsettings = setttab:CreateSection("Настройки авто-диспенсера и усилителей")
dispsettings:CreateToggle("Диспенсер королевских желе", nil, function(State) jeq.dispensesettings.rj = not jeq.dispensesettings.rj end)
dispsettings:CreateToggle("Диспенсер голубики", nil, function(State) jeq.dispensesettings.blub = not jeq.dispensesettings.blub end)
dispsettings:CreateToggle("Диспенсер земляники", nil, function(State) jeq.dispensesettings.straw = not jeq.dispensesettings.straw end)
dispsettings:CreateToggle("Диспенсер лакомств", nil, function(State) jeq.dispensesettings.treat = not jeq.dispensesettings.treat end)
dispsettings:CreateToggle("Диспенсер кокосов", nil, function(State) jeq.dispensesettings.coconut = not jeq.dispensesettings.coconut end)
dispsettings:CreateToggle("Диспенсер клея", nil, function(State) jeq.dispensesettings.glue = not jeq.dispensesettings.glue end)
dispsettings:CreateToggle("Усилитель на горе", nil, function(State) jeq.dispensesettings.white = not jeq.dispensesettings.white end)
dispsettings:CreateToggle("Усилитель на голубом поле", nil, function(State) jeq.dispensesettings.blue = not jeq.dispensesettings.blue end)
dispsettings:CreateToggle("Усилитель на красном поле", nil, function(State) jeq.dispensesettings.red = not jeq.dispensesettings.red end)

local guisettings = setttab:CreateSection("Настройки интерфейса")
local uitoggle = guisettings:CreateToggle("Включить/выключить интерфейс", nil, function(State) Window:Toggle(State) end)
uitoggle:CreateKeybind(tostring(Config.Keybind):gsub("Enum.KeyCode.", ""), function(Key) Config.Keybind = Enum.KeyCode[Key] end)
uitoggle:SetState(true)

guisettings:CreateColorpicker("Цвет интерфейса", function(Color) Window:ChangeColor(Color) end)

local themes = guisettings:CreateDropdown("Фон", {"По умолчанию", "Сердца", "Абстракция", "Гексагоны", "Круги", "Кружево с цветами", "Флора"}, function(Name)
    if Name == "По умолчанию" then
        Window:SetBackground("2151741365")
    elseif Name == "Сердца" then
        Window:SetBackground("6073763717")
    elseif Name == "Абстракция" then
        Window:SetBackground("6073743871")
    elseif Name == "Гексагоны" then
        Window:SetBackground("6073628839")
    elseif Name == "Круги" then
        Window:SetBackground("6071579801")
    elseif Name == "Кружево с цветами" then
        Window:SetBackground("6071575925")
    elseif Name == "Флора" then
        Window:SetBackground("5553946656")
    end
end)
themes:SetOption("По умолчанию")

local jeq = setttab:CreateSection("Конфигурации")
jeq:CreateTextBox("Название конфигурации", 'например: stumpconfig', false, function(Value) temptable.configname = Value end)
jeq:CreateButton("Загрузить конфигурацию", function() jeq = game:service'HttpService':JSONDecode(readfile("jeq/BSS_"..temptable.configname..".json")) end)
jeq:CreateButton("Сохранить конфигурацию", function() writefile("jeq/BSS_"..temptable.configname..".json", game:service'HttpService':JSONEncode(jeq)) end)
jeq:CreateButton("Сбросить конфигурацию", function() jeq = defaultjeq end)

local fieldsettings = setttab:CreateSection("Настройки полей")
fieldsettings:CreateDropdown("Лучшее белое поле", temptable.whitefields, function(Option) jeq.bestfields.white = Option end)
fieldsettings:CreateDropdown("Лучшее красное поле", temptable.redfields, function(Option) jeq.bestfields.red = Option end)
fieldsettings:CreateDropdown("Лучшее голубое поле", temptable.bluefields, function(Option) jeq.bestfields.blue = Option end)
fieldsettings:CreateDropdown("Поле", fieldstable, function(Option) temptable.blackfield = Option end)
fieldsettings:CreateButton("Добавить поле в черный список", function()
    table.insert(jeq.blacklistedfields, temptable.blackfield)
    game:GetService("CoreGui"):FindFirstChild(_G.windowname).Main:FindFirstChild("Черный список полей D", true):Destroy()
    fieldsettings:CreateDropdown("Черный список полей", jeq.blacklistedfields, function(Option) end)
end)
fieldsettings:CreateButton("Удалить поле из черного списка", function()
    table.remove(jeq.blacklistedfields, api.tablefind(jeq.blacklistedfields, temptable.blackfield))
    game:GetService("CoreGui"):FindFirstChild(_G.windowname).Main:FindFirstChild("Blacklisted Fields D",true):Destroy()
    fieldsettings:CreateDropdown("Blacklisted Fields", jeq.blacklistedfields, function(Option) end)
end)

  loadingUI:UpdateText("Загрузка интерфейса")
local loadingLoops = loadingInfo:CreateLabel("Загрузка циклов..")

-- скрипт

local honeytoggleouyfyt = false
task.spawn(function()
    while wait(1) do
        if jeq.toggles.honeymaskconv == true then
            if temptable.converting then
                if honeytoggleouyfyt == false then
                    honeytoggleouyfyt = true
                    game:GetService("ReplicatedStorage").Events.ItemPackageEvent:InvokeServer("Equip", {Mute=false;Type="Honey Mask";Category="Accessory"})
                end
            else
                if honeytoggleouyfyt == true then
                    honeytoggleouyfyt = false
                    game:GetService("ReplicatedStorage").Events.ItemPackageEvent:InvokeServer("Equip", {Mute=false;Type=jeq.vars.defmask;Category="Accessory"})
                end
            end
        end
    end
end)

task.spawn(function()
    while wait(5) do
        local buffs = fetchBuffTable(buffTable)
        for i,v in pairs(buffTable) do
            if v["b"] == true then
                local inuse = false
                for k,p in pairs(buffs) do
                    if k == i then inuse = true end
                end
                if inuse == false then
                    game:GetService("ReplicatedStorage").Events.PlayerActivesCommand:FireServer({["Name"]=i})
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.05) do
        if jeq.toggles.autofarm then
            if jeq.toggles.farmflame then getflame() end
            if jeq.toggles.farmfuzzy then getfuzzy() end
            if jeq.toggles.farmduped then getdupe() end
        end
    end
end)

game.Workspace.Particles.ChildAdded:Connect(function(v)
    if not temptable.started.vicious and not temptable.started.ant then
        if v.Name == "WarningDisk" and not temptable.started.vicious and jeq.toggles.autofarm and not temptable.started.ant and jeq.toggles.farmcoco and (v.Position-api.humanoidrootpart().Position).magnitude < temptable.magnitude and not temptable.converting then
            table.insert(temptable.coconuts, v)
            getcoco(v)
            gettoken()
        elseif v.Name == "Crosshair" and v ~= nil and v.BrickColor ~= BrickColor.new("Forest green") and not temptable.started.ant and v.BrickColor ~= BrickColor.new("Flint") and (v.Position-api.humanoidrootpart().Position).magnitude < temptable.magnitude and jeq.toggles.autofarm and jeq.toggles.collectcrosshairs and not temptable.converting then
            if #temptable.crosshairs <= 3 then
                table.insert(temptable.crosshairs, v)
                getcrosshairs(v)
                gettoken()
            end
        end
    end
end)

task.spawn(function()
    while task.wait() do
        temptable.magnitude = 50
        if game.Players.LocalPlayer.Character:FindFirstChild("ProgressLabel",true) then
            local pollenprglbl = game.Players.LocalPlayer.Character:FindFirstChild("ProgressLabel",true)
            maxpollen = tonumber(pollenprglbl.Text:match("%d+$"))
            local pollencount = game.Players.LocalPlayer.CoreStats.Pollen.Value
            pollenpercentage = pollencount/maxpollen*100
            fieldselected = game:GetService("Workspace").FlowerZones[jeq.vars.field]
        
            if jeq.toggles.autouseconvertors == true then
                if tonumber(pollenpercentage) >= (jeq.vars.convertat - (jeq.vars.autoconvertWaitTime)) then
                    if not temptable.consideringautoconverting then
                        temptable.consideringautoconverting = true
                        spawn(function()
                            wait(jeq.vars.autoconvertWaitTime)
                            if tonumber(pollenpercentage) >= (jeq.vars.convertat - (jeq.vars.autoconvertWaitTime)) then
                                useConvertors()
                            end
                            temptable.consideringautoconverting = false
                        end)
                    end
                end
            end
        end
    end
end)

if jeq.toggles.autofarm then
    if jeq.toggles.autodoquest and game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.Menus.Children.Quests.Content:FindFirstChild("Frame") then
        for i,v in next, game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.Menus.Children.Quests:GetDescendants() do
            if v.Name == "Description" then
                if string.match(v.Parent.Parent.TitleBar.Text, jeq.vars.npcprefer) or jeq.vars.npcprefer == "All Quests" and not string.find(v.Text, "Puffshroom") then
                    pollentypes = {'White Pollen', "Red Pollen", "Blue Pollen", "Blue Flowers", "Red Flowers", "White Flowers"}
                    text = v.Text
                    if api.returnvalue(fieldstable, text) and not string.find(v.Text, "Complete!") and not api.findvalue(jeq.blacklistedfields, api.returnvalue(fieldstable, text)) then
                        d = api.returnvalue(fieldstable, text)
                        fieldselected = game:GetService("Workspace").FlowerZones[d]
                        break
                    elseif api.returnvalue(pollentypes, text) and not string.find(v.Text, 'Complete!') then
                        d = api.returnvalue(pollentypes, text)
                        if d == "Blue Flowers" or d == "Blue Pollen" then
                            fieldselected = game:GetService("Workspace").FlowerZones[jeq.bestfields.blue]
                            break
                        elseif d == "White Flowers" or d == "White Pollen" then
                            fieldselected = game:GetService("Workspace").FlowerZones[jeq.bestfields.white]
                            break
                        elseif d == "Red Flowers" or d == "Red Pollen" then
                            fieldselected = game:GetService("Workspace").FlowerZones[jeq.bestfields.red]
                            break
                        end
                    end
                end
            end
        end
    else
        fieldselected = game:GetService("Workspace").FlowerZones[jeq.vars.field]
    end
    fieldpos = CFrame.new(fieldselected.Position.X, fieldselected.Position.Y+3, fieldselected.Position.Z)
    fieldposition = fieldselected.Position
    if temptable.sprouts.detected and temptable.sprouts.coords and jeq.toggles.farmsprouts then
        fieldposition = temptable.sprouts.coords.Position
        fieldpos = temptable.sprouts.coords
    end
    if jeq.toggles.farmpuffshrooms and game.Workspace.Happenings.Puffshrooms:FindFirstChildOfClass("Model") then 
        if api.partwithnamepart("Mythic", game.Workspace.Happenings.Puffshrooms) then
            temptable.magnitude = 25 
            fieldpos = api.partwithnamepart("Mythic", game.Workspace.Happenings.Puffshrooms):FindFirstChild("Puffball Stem").CFrame
            fieldposition = fieldpos.Position
        elseif api.partwithnamepart("Legendary", game.Workspace.Happenings.Puffshrooms) then
            temptable.magnitude = 25 
            fieldpos = api.partwithnamepart("Legendary", game.Workspace.Happenings.Puffshrooms):FindFirstChild("Puffball Stem").CFrame
            fieldposition = fieldpos.Position
        elseif api.partwithnamepart("Epic", game.Workspace.Happenings.Puffshrooms) then
            temptable.magnitude = 25 
            fieldpos = api.partwithnamepart("Epic", game.Workspace.Happenings.Puffshrooms):FindFirstChild("Puffball Stem").CFrame
            fieldposition = fieldpos.Position
        elseif api.partwithnamepart("Rare", game.Workspace.Happenings.Puffshrooms) then
            temptable.magnitude = 25 
            fieldpos = api.partwithnamepart("Rare", game.Workspace.Happenings.Puffshrooms):FindFirstChild("Puffball Stem").CFrame
            fieldposition = fieldpos.Position
        else
            temptable.magnitude = 25 
            fieldpos = api.getbiggestmodel(game.Workspace.Happenings.Puffshrooms):FindFirstChild("Puffball Stem").CFrame
            fieldposition = fieldpos.Position
        end
    end
    
    if (tonumber(pollenpercentage) < tonumber(jeq.vars.convertat)) or (jeq.toggles.disableconversion == true) then
        if not temptable.tokensfarm then
            api.tween(2, fieldpos)
            task.wait(2)
            temptable.tokensfarm = true
            if jeq.toggles.autosprinkler then makesprinklers() end
        else
            if jeq.toggles.killmondo then
                while jeq.toggles.killmondo and game.Workspace.Monsters:FindFirstChild("Mondo Chick (Lvl 8)") and not temptable.started.vicious and not temptable.started.monsters do
                    temptable.started.mondo = true
                    while game.Workspace.Monsters:FindFirstChild("Mondo Chick (Lvl 8)") do
                        disableall()
                        game:GetService("Workspace").Map.Ground.HighBlock.CanCollide = false 
                        mondopition = game.Workspace.Monsters["Mondo Chick (Lvl 8)"].Head.Position
                        api.tween(1, CFrame.new(mondopition.x, mondopition.y - 60, mondopition.z))
                        task.wait(1)
                        temptable.float = true
                    end
                    task.wait(.5) game:GetService("Workspace").Map.Ground.HighBlock.CanCollide = true temptable.float = false api.tween(.5, CFrame.new(73.2, 176.35, -167)) task.wait(1)
                    for i = 0, 50 do 
                        gettoken(CFrame.new(73.2, 176.35, -167).Position) 
                    end 
                    enableall() 
                    api.tween(2, fieldpos) 
                    temptable.started.mondo = false
                end
            end
            if (fieldposition-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > temptable.magnitude then
                api.tween(0.1, fieldpos)
                task.wait(2)
                if jeq.toggles.autosprinkler then makesprinklers() end
            end
            getprioritytokens()
            if jeq.toggles.avoidmobs then avoidmob() end
            if jeq.toggles.farmclosestleaf then closestleaf() end
            if jeq.toggles.farmbubbles then getbubble() end
            if jeq.toggles.farmclouds then getcloud() end
            if jeq.toggles.farmunderballoons then getballoons() end
            if not jeq.toggles.donotfarmtokens and done then gettoken() end
            if not jeq.toggles.farmflower then getflower() end
        end
    elseif tonumber(pollenpercentage) >= tonumber(jeq.vars.convertat) then
        if not jeq.toggles.disableconversion then
            temptable.tokensfarm = false
            api.tween(2, game:GetService("Players").LocalPlayer.SpawnPos.Value * CFrame.fromEulerAnglesXYZ(0, 110, 0) + Vector3.new(0, 0, 9))
            task.wait(2)
            temptable.converting = true
            repeat
                converthoney()
            until game.Players.LocalPlayer.CoreStats.Pollen.Value == 0
            if jeq.toggles.convertballoons and gethiveballoon() then
                task.wait(6)
                repeat
                    task.wait()
                    converthoney()
                until gethiveballoon() == false or not jeq.toggles.convertballoons
            end
            temptable.converting = false
            temptable.act = temptable.act + 1
            task.wait(6)
            if jeq.toggles.autoant and not game:GetService("Workspace").Toys["Ant Challenge"].Busy.Value and rtsg().Eggs.AntPass > 0 then farmant() end
            if jeq.toggles.autoquest then makequests() end
            if jeq.toggles.autoplanters then collectplanters() end
            if jeq.toggles.autokillmobs then 
                if temptable.act >= jeq.vars.monstertimer then
                    temptable.started.monsters = true
                    temptable.act = 0
                    killmobs() 
                    temptable.started.monsters = false
                end
            end
            if jeq.vars.resetbeeenergy then
                if temptable.act2 >= jeq.vars.resettimer then
                    temptable.started.monsters = true
                    temptable.act2 = 0
                    repeat wait() until workspace:FindFirstChild(game.Players.LocalPlayer.Name) and workspace:FindFirstChild(game.Players.LocalPlayer.Name):FindFirstChild("Humanoid") and workspace:FindFirstChild(game.Players.LocalPlayer.Name):FindFirstChild("Humanoid").Health > 0
                    workspace:FindFirstChild(game.Players.LocalPlayer.Name):BreakJoints()
                    wait(6.5)
                    repeat wait() until workspace:FindFirstChild(game.Players.LocalPlayer.Name)
                    workspace:FindFirstChild(game.Players.LocalPlayer.Name):BreakJoints()
                    wait(6.5)
                    repeat wait() until workspace:FindFirstChild(game.Players.LocalPlayer.Name)
                    temptable.started.monsters = false
                end
            end
        end
    end
end

task.spawn(function()
    while task.wait(1) do
        if jeq.toggles.killvicious and temptable.detected.vicious and temptable.converting == false and not temptable.started.monsters then
            temptable.started.vicious = true
            disableall()
            local vichumanoid = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
            for i,v in next, game.workspace.Particles:GetChildren() do
                for x in string.gmatch(v.Name, "Vicious") do
                    if string.find(v.Name, "Vicious") then
                        api.tween(1,CFrame.new(v.Position.x, v.Position.y, v.Position.z))
                        task.wait(1)
                        api.tween(0.5, CFrame.new(v.Position.x, v.Position.y, v.Position.z))
                        task.wait(.5)
                    end
                end
            end
            for i,v in next, game.workspace.Particles:GetChildren() do
                for x in string.gmatch(v.Name, "Vicious") do
                    while jeq.toggles.killvicious and temptable.detected.vicious do
                        task.wait()
                        if string.find(v.Name, "Vicious") then
                            for i=1, 4 do
                                temptable.float = true
                                vichumanoid.CFrame = CFrame.new(v.Position.x+10, v.Position.y, v.Position.z)
                                task.wait(.3)
                            end
                        end
                    end
                end
            end
            enableall()
            task.wait(1)
            temptable.float = false
            temptable.started.vicious = false
        end
    end
end)

task.spawn(function() 
    while task.wait() do
        if jeq.toggles.killwindy and temptable.detected.windy and not temptable.converting and not temptable.started.vicious and not temptable.started.mondo and not temptable.started.monsters then
            temptable.started.windy = true
            wlvl = ""
            aw = false
            awb = false -- some variable for autowindy, yk?
            disableall()
            while jeq.toggles.killwindy and temptable.detected.windy do
                if not aw then
                    for i,v in pairs(workspace.Monsters:GetChildren()) do
                        if string.find(v.Name, "Windy") then
                            wlvl = v.Name
                            aw = true -- we found windy!
                        end
                    end
                end
                if aw then
                    for i,v in pairs(workspace.Monsters:GetChildren()) do
                        if string.find(v.Name, "Windy") then
                            if v.Name ~= wlvl then
                                temptable.float = false
                                task.wait(5)
                                for i =1, 5 do
                                    gettoken(api.humanoidrootpart().Position)
                                end -- collect tokens :yessir:
                                wlvl = v.Name
                            end
                        end
                    end
                end
                if not awb then
                    api.tween(1,temptable.gacf(temptable.windy, 5))
                    task.wait(1)
                    awb = true
                end
                if awb and temptable.windy.Name == "Windy" then
                    api.humanoidrootpart().CFrame = temptable.gacf(temptable.windy, 25)
                    temptable.float = true
                    task.wait()
                end
            end 
            enableall()
            temptable.float = false
            temptable.started.windy = false
        end
    end
end)

local function collectorSteal()
    if jeq.vars.autodigmode == "Collector Steal" then
        for i,v in pairs(game.Players:GetChildren()) do
            if v.Name ~= game.Players.LocalPlayer.Name then
                if v then
                    if v.Character then
                        if v.Character:FindFirstChildWhichIsA("Tool") then
                            if v.Character:FindFirstChildWhichIsA("Tool"):FindFirstChild("ClickEvent") then
                                v.Character:FindFirstChildWhichIsA("Tool").ClickEvent:FireServer()
                            end
                        end
                    end
                end
            end
        end
    end
end

task.spawn(function()
    while task.wait(0.05) do
        -- Проверяем, включена ли опция для фарма редких предметов
        if jeq.toggles.farmrares then
            -- Перебираем дочерние элементы в workspace.Collectibles
            for k,v in next, game.workspace.Collectibles:GetChildren() do
                -- Проверяем, что Y-вектор равен 1 (проверка на нахождение на земле)
                if v.CFrame.YVector.Y == 1 then
                    -- Проверяем, что предмет не прозрачный (видимый)
                    if v.Transparency == 0 then
                        -- Находим декаль (Decal) у предмета
                        decal = v:FindFirstChildOfClass("Decal")
                        -- Перебираем редкие текстуры из jeq.rares
                        for e,r in next, jeq.rares do
                            -- Проверяем, соответствует ли текстура редкой текстуре
                            if decal.Texture == r or decal.Texture == "rbxassetid://"..r then
                                -- Перемещаем игрока к предмету
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
                                break
                            end
                        end
                    end
                end
            end
        end

        -- Проверяем, включена ли опция для автоматического добычи
        if jeq.toggles.autodig then
            pcall(function()
                if game.Players.LocalPlayer then
                    if game.Players.LocalPlayer.Character then
                        if game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool") then
                            if game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool"):FindFirstChild("ClickEvent", true) then
                                tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool") or nil
                            end
                        end
                    end

                    if tool then
                        -- Запускаем функцию для сбора с помощью инструмента
                        getsenv(tool.ClientScriptMouse).collectStart(game:GetService("Players").LocalPlayer:GetMouse())
                    end
                end
                -- Вызываем функцию для кражи у Collector Bee
                collectorSteal()
                -- Вызываем функцию для сбора меда у Onett
                workspace.NPCs.Onett.Onett["Porcelain Dipper"].ClickEvent:FireServer()
            end)
        end
    end
end)

-- Обработчик события добавления объекта "Sprout" в папку Particles/Folder2
game:GetService("Workspace").Particles.Folder2.ChildAdded:Connect(function(child)
    if child.Name == "Sprout" then
        temptable.sprouts.detected = true
        temptable.sprouts.coords = child.CFrame
    end
end)

-- Обработчик события удаления объекта "Sprout" из папки Particles/Folder2
game:GetService("Workspace").Particles.Folder2.ChildRemoved:Connect(function(child)
    if child.Name == "Sprout" then
        task.wait(30) -- Ждем 30 секунд
        temptable.sprouts.detected = false
        temptable.sprouts.coords = ""
    end
end)

-- Обработчик события добавления объекта с именем, содержащим "Vicious" в workspace.Particles
Workspace.Particles.ChildAdded:Connect(function(instance)
    if string.find(instance.Name, "Vicious") then
        temptable.detected.vicious = true
    end
end)

-- Обработчик события удаления объекта с именем, содержащим "Vicious" из workspace.Particles
Workspace.Particles.ChildRemoved:Connect(function(instance)
    if string.find(instance.Name, "Vicious") then
        temptable.detected.vicious = false
    end
end)

-- Обработчик события добавления объекта "Windy" в workspace.NPCBees
game:GetService("Workspace").NPCBees.ChildAdded:Connect(function(v)
    if v.Name == "Windy" then
        task.wait(3)
        temptable.windy = v
        temptable.detected.windy = true
    end
end)

-- Обработчик события удаления объекта "Windy" из workspace.NPCBees
game:GetService("Workspace").NPCBees.ChildRemoved:Connect(function(v)
    if v.Name == "Windy" then
        task.wait(3)
        temptable.windy = nil
        temptable.detected.windy = false
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        -- Проверяем, не идет ли процесс конвертации
        if not temptable.converting then
            -- Проверяем, включена ли опция для автоматического использования "Samovar"
            if jeq.toggles.autosamovar then
                -- Отправляем серверное событие для использования "Samovar"
                game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Samovar")
                -- Получаем позицию платформы "Samovar"
                platformm = game:GetService("Workspace").Toys.Samovar.Platform
                -- Перебираем дочерние элементы в workspace.Collectibles
                for i,v in pairs(game.Workspace.Collectibles:GetChildren()) do
                    -- Проверяем, находится ли предмет близко к платформе и на земле
                    if (v.Position-platformm.Position).magnitude < 25 and v.CFrame.YVector.Y == 1 then
                        -- Перемещаем игрока к предмету
                        api.humanoidrootpart().CFrame = v.CFrame
                    end
                end
            end
            -- Проверяем, включена ли опция для автоматического использования "Snow Machine"
            if jeq.toggles.autosnowmachines then
                -- Отправляем серверное событие для использования "Snow Machine"
                game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Snow Machine")
            end
            -- Проверяем, включена ли опция для автоматического использования "Stockings"
            if jeq.toggles.autostockings then
                -- Отправляем серверное событие для использования "Stockings"
                game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Stockings")
                -- Получаем позицию платформы "Stockings"
                platformm = game:GetService("Workspace").Toys.Stockings.Platform
                -- Перебираем дочерние элементы в workspace.Collectibles
                for i,v in pairs(game.Workspace.Collectibles:GetChildren()) do
                    -- Проверяем, находится ли предмет близко к платформе и на земле
                    if (v.Position-platformm.Position).magnitude < 25 and v.CFrame.YVector.Y == 1 then
                        -- Перемещаем игрока к предмету
                        api.humanoidrootpart().CFrame = v.CFrame
                    end
                end
            end
            -- Проверяем, включена ли опция для автоматического использования "Honey Wreath"
            if jeq.toggles.autoonettart then
                -- Отправляем серверное событие для использования "Honey Wreath"
                game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Honey Wreath")
                -- Получаем позицию платформы "Honey Wreath"
                platformm = game:GetService("Workspace").Toys["Honey Wreath"].Platform
                -- Перебираем дочерние элементы в workspace.Collectibles
                for i,v in pairs(game.Workspace.Collectibles:GetChildren()) do
                    -- Проверяем, находится ли предмет близко к платформе и на земле
                    if (v.Position-platformm.Position).magnitude < 25 and v.CFrame.YVector.Y == 1 then
                        -- Перемещаем игрока к предмету
                        api.humanoidrootpart().CFrame = v.CFrame
                    end
                end
            end
            -- Проверяем, включена ли опция для автоматического использования "Onett's Lid Art"
            if jeq.toggles.autoonettart then
                -- Отправляем серверное событие для использования "Onett's Lid Art"
                game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Onett's Lid Art")
                -- Получаем позицию платформы "Onett's Lid Art"
                platformm = game:GetService("Workspace").Toys["Onett's Lid Art"].Platform
                -- Перебираем дочерние элементы в workspace.Collectibles
                for i,v in pairs(game.Workspace.Collectibles:GetChildren()) do
                    -- Проверяем, находится ли предмет близко к платформе и на земле
                    if (v.Position-platformm.Position).magnitude < 25 and v.CFrame.YVector.Y == 1 then
                        -- Перемещаем игрока к предмету
                        api.humanoidrootpart().CFrame = v.CFrame
                    end
                end
            end
            -- Проверяем, включена ли опция для автоматического использования "Honeyday Candles"
            if jeq.toggles.autocandles then
                -- Отправляем серверное событие для использования "Honeyday Candles"
                game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Honeyday Candles")
                -- Получаем позицию платформы "Honeyday Candles"
                platformm = game:GetService("Workspace").Toys["Honeyday Candles"].Platform
                -- Перебираем дочерние элементы в workspace.Collectibles
                for i,v in pairs(game.Workspace.Collectibles:GetChildren()) do
                    -- Проверяем, находится ли предмет близко к платформе и на земле
                    if (v.Position-platformm.Position).magnitude < 25 and v.CFrame.YVector.Y == 1 then
                        -- Перемещаем игрока к предмету
                        api.humanoidrootpart().CFrame = v.CFrame
                    end
                end
            end
            -- Проверяем, включена ли опция для автоматического использования "Beesmas Feast"
            if jeq.toggles.autofeast then
                -- Отправляем серверное событие для использования "Beesmas Feast"
                game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Beesmas Feast")
                -- Получаем позицию платформы "Beesmas Feast"
                platformm = game:GetService("Workspace").Toys["Beesmas Feast"].Platform
                -- Перебираем дочерние элементы в workspace.Collectibles
                for i,v in pairs(game.Workspace.Collectibles:GetChildren()) do
                    -- Проверяем, находится ли предмет близко к платформе и на земле
                    if (v.Position-platformm.Position).magnitude < 25 and v.CFrame.YVector.Y == 1 then
                        -- Перемещаем игрока к предмету
                        api.humanoidrootpart().CFrame = v.CFrame
                    end
                end
            end
            -- Проверяем, включена ли опция для автоматического пожертвования
            if jeq.toggles.autodonate then
                -- Проверяем, не находится ли Wind Shrine на перезарядке
                if isWindshrineOnCooldown() == false then
                    -- Пожертвование в Wind Shrine с указанными предметами и количеством
                    donateToShrine(jeq.vars.donoItem, jeq.vars.donoAmount)
                end
            end
        end
    end
end)

-- Этот код выполняется каждую секунду
task.spawn(function()
    while task.wait(1) do
        temptable.runningfor = temptable.runningfor + 1 -- Увеличиваем счетчик времени выполнения

        temptable.honeycurrent = statsget().Totals.Honey -- Получаем текущее количество меда

        -- Проверяем, включена ли опция "Honeystorm" и выполняем ее, если да
        if jeq.toggles.honeystorm then
            game.ReplicatedStorage.Events.ToyEvent:FireServer("Honeystorm")
        end

        -- Проверяем, включена ли опция "Gingerbread House" и выполняем ее, если да
        if jeq.toggles.collectgingerbreads then
            game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Gingerbread House")
        end

        -- Проверяем, включена ли опция "autodispense" и выполняем соответствующие действия
        if jeq.toggles.autodispense then
            if jeq.dispensesettings.rj then
                local A_1 = "Free Royal Jelly Dispenser"
                local Event = game:GetService("ReplicatedStorage").Events.ToyEvent
                Event:FireServer(A_1)
            end

            if jeq.dispensesettings.blub then
                game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Blueberry Dispenser")
            end

            if jeq.dispensesettings.straw then
                game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Strawberry Dispenser")
            end

            if jeq.dispensesettings.treat then
                game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Treat Dispenser")
            end

            if jeq.dispensesettings.coconut then
                game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Coconut Dispenser")
            end

            if jeq.dispensesettings.glue then
                game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Glue Dispenser")
            end
        end

        -- Проверяем, включена ли опция "autoboosters" и выполняем соответствующие действия
        if jeq.toggles.autoboosters then
            if jeq.dispensesettings.white then
                game.ReplicatedStorage.Events.ToyEvent:FireServer("Field Booster")
            end

            if jeq.dispensesettings.red then
                game.ReplicatedStorage.Events.ToyEvent:FireServer("Red Field Booster")
            end

            if jeq.dispensesettings.blue then
                game.ReplicatedStorage.Events.ToyEvent:FireServer("Blue Field Booster")
            end
        end

        -- Проверяем, включена ли опция "Wealth Clock" и выполняем ее, если да
        if jeq.toggles.clock then
            game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Wealth Clock")
        end

        -- Проверяем, включена ли опция "Free Ant Pass Dispenser" и выполняем ее, если да
        if jeq.toggles.freeantpass then
            game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Free Ant Pass Dispenser")
        end

        -- Обновляем текстовую метку с информацией о полученном меде
        gainedhoneylabel:UpdateText("Gained Honey: "..api.suffixstring(temptable.honeycurrent - temptable.honeystart))
    end
end)

-- Этот код выполняется каждый тик
game:GetService('RunService').Heartbeat:connect(function() 
    -- Проверяем, включена ли опция "autoquest" и выполняем действие
    if jeq.toggles.autoquest then
        firesignal(game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.NPC.ButtonOverlay.MouseButton1Click)
    end

    -- Проверяем, включена ли опция "loopspeed" и изменяем скорость ходьбы игрока
    if jeq.toggles.loopspeed then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = jeq.vars.walkspeed
    end

    -- Проверяем, включена ли опция "loopjump" и изменяем высоту прыжка игрока
    if jeq.toggles.loopjump then
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = jeq.vars.jumppower
    end
end)

-- Этот код выполняется каждый тик
game:GetService('RunService').Heartbeat:connect(function()
    -- Перебираем элементы в игре, чтобы отображать их
    for i,v in next, game.Players.LocalPlayer.PlayerGui.ScreenGui:WaitForChild("MinigameLayer"):GetChildren() do
        for k,q in next, v:WaitForChild("GuiGrid"):GetDescendants() do
            if q.Name == "ObjContent" or q.Name == "ObjImage" then
                q.Visible = true
            end
        end
    end
end)

-- Этот код выполняется каждый тик
game:GetService('RunService').Heartbeat:connect(function() 
    -- Проверяем, включена ли опция "float" и выполняем соответствующие действия
    if temptable.float then
        game.Players.LocalPlayer.Character.Humanoid.BodyTypeScale.Value = 0
        floatpad.CanCollide = true
        floatpad.CFrame = CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.Position.X, game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Y-3.75, game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Z)
        task.wait(0)
    else
        floatpad.CanCollide = false
    end
end)

-- Этот код позволяет избегать отключения игры при бездействии
local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:connect(function() 
    vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    task.wait(1)
    vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

-- Этот код выполняется, когда появляется снежинка
local canTeleport = true
game:GetService("Workspace").Particles.Snowflakes.ChildAdded:Connect(function(snowflake)
    if canTeleport == true and jeq.toggles.farmsnowflakes == true then
        local hash = tostring(math.random(1,10000))
        snowflake.Name = hash
        canTeleport = false
        repeat
            wait()
            getgenv().temptable.float = true
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = snowflake.CFrame + Vector3.new(0,7.5,0)
        until game:GetService("Workspace").Particles.Snowflakes:FindFirstChild(hash) == nil
        getgenv().temptable.float = false
        wait(1)
        canTeleport = true
    end
end)

-- Этот код выполняется, когда персонаж игрока умирает
game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
    humanoid = char:WaitForChild("Humanoid")
    humanoid.Died:Connect(function()
        if jeq.toggles.autofarm then
            temptable.dead = true
            jeq.toggles.autofarm = false
            temptable.converting = false
            temptable.farmtoken = false
        end
        if temptable.dead then
            task.wait(25)
            temptable.dead = false
            jeq.toggles.autofarm = true
            local player = game.Players.LocalPlayer
            temptable.converting = false
            temptable.tokensfarm = true
        end
    end)
end)

-- Этот код удаляет некоторые элементы из игры
for _,v in next, game.workspace.Collectibles:GetChildren() do
    if string.find(v.Name,"") then
        v:Destroy()
    end
end 

-- Этот код выполняется каждый тик и определяет, движется ли персонаж игрока
task.spawn(function()
    while task.wait() do
        pos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
        task.wait(0.00001)
        currentSpeed = (pos-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude
        if currentSpeed > 0 then
            temptable.running = true
        else
            temptable.running = false
        end
    end
end)

-- Обновляем текстовую метку "Loaded Loops"
loadingLoops:UpdateText("Loaded Loops")

-- Функция для получения улучшенного имени монстра на основе входного имени
local function getMonsterName(name)
    local newName = nil
    local keywords = {
        ["Mushroom"] = "Ladybug";  -- Если имя содержит "Mushroom", заменить на "Ladybug"
        ["Rhino"] = "Rhino Beetle"; -- Если имя содержит "Rhino", заменить на "Rhino Beetle"
        -- Добавьте другие ключи и замените на соответствующие значения
    }

    -- Проверяем входное имя на совпадение с ключами
    for i, v in pairs(keywords) do
        if string.find(string.upper(name), string.upper(i)) then
            newName = v
        end
    end

    -- Если не найдено совпадений, используется исходное имя
    if newName == nil then
        newName = name
    end

    return newName
end

-- Функция для получения позиции ближайшего поля цветов относительно части (монстра)
local function getNearestField(part)
    local resultingFieldPos
    local lowestMag = math.huge

    -- Перебираем все поля цветов в игре
    for i, v in pairs(game:GetService("Workspace").FlowerZones:GetChildren()) do
        -- Вычисляем расстояние между частью и полем
        local distance = (v.Position - part.Position).magnitude

        -- Если это ближайшее поле, обновляем позицию
        if distance < lowestMag then
            lowestMag = distance
            resultingFieldPos = v.Position
        end
    end

    -- Если ближайшего поля нет на расстоянии менее 100, возвращаем позицию с смещением по высоте
    if lowestMag > 100 then
        resultingFieldPos = part.Position + Vector3.new(0, 0, 10)
    end

    -- Если часть имеет имя "Tunnel", возвращаем другую позицию
    if string.find(part.Name, "Tunnel") then
        resultingFieldPos = part.Position + Vector3.new(20, -70, 0)
    end

    return resultingFieldPos
end

-- Функция для извлечения строки монстра для отображения в панели
local function fetchVisualMonsterString(v)
    local mobText = nil

    -- Проверяем наличие нужных компонентов в монстре
    if v:FindFirstChild("Attachment") then
        if v:FindFirstChild("Attachment"):FindFirstChild("TimerGui") then
            if v:FindFirstChild("Attachment"):FindFirstChild("TimerGui"):FindFirstChild("TimerLabel") then
                if v:FindFirstChild("Attachment"):FindFirstChild("TimerGui"):FindFirstChild("TimerLabel").Visible == true then
                    -- Разбиваем строку таймера и формируем текст монстра
                    local splitTimer = string.split(v:FindFirstChild("Attachment"):FindFirstChild("TimerGui"):FindFirstChild("TimerLabel").Text, " ")
                    if splitTimer[3] ~= nil then
                        mobText = getMonsterName(v.Name) .. ": " .. splitTimer[3]
                    elseif splitTimer[2] ~= nil then
                        mobText = getMonsterName(v.Name) .. ": " .. splitTimer[2]
                    else
                        mobText = getMonsterName(v.Name) .. ": " .. splitTimer[1]
                    end
                else
                    mobText = getMonsterName(v.Name) .. ": Ready"
                end
            end
        end
    end

    return mobText
end

-- Функция для получения времени восстановления игрушки и её состояния (готова или нет)
local function getToyCooldown(toy)
    local c = require(game.ReplicatedStorage.ClientStatCache):Get()
    local name = toy
    local t = workspace.OsTime.Value - c.ToyTimes[name]
    local cooldown = workspace.Toys[name].Cooldown.Value
    local u = cooldown - t
    local canBeUsed = false

    -- Проверяем, можно ли использовать игрушку (отрицательное время означает готовность)
    if string.find(tostring(u), "-") then
        canBeUsed = true
    end

    return u, canBeUsed
end

-- Основной цикл скрипта
task.spawn(function()
    pcall(function()
        loadingInfo:CreateLabel("")
        loadingInfo:CreateLabel("Script loaded!")
        wait(2)

        pcall(function()
            -- Убираем экранную информацию о загрузке, если она есть
            for i, v in pairs(game.CoreGui:GetDescendants()) do
                if v.Name == "Startup S" then
                    v.Parent.Parent.RightSide["Information S"].Parent = v.Parent
                    v:Destroy()
                end
            end
        end)

        -- Создаем разделы в панели
        local panel = hometab:CreateSection("Mob Panel")
        local statusTable = {}

        -- Перебираем монстров в игре и добавляем их в панель
        for i, v in pairs(game:GetService("Workspace").MonsterSpawners:GetChildren()) do
            if not string.find(v.Name, "CaveMonster") then
                local mobText = nil
                mobText = fetchVisualMonsterString(v)

                -- Если удалось получить текст монстра, создаем кнопку для него
                if mobText ~= nil then
                    local mob = panel:CreateButton(mobText, function()
                        -- При клике на кнопку монстра выполняется анимация передвижения к ближайшему полю цветов
                        api.tween(1, CFrame.new(getNearestField(v)))
                    end)
                    table.insert(statusTable, {mob, v})
                end
            end
        end

        -- Создаем кнопку для Mondo Chick
        local mob2 = panel:CreateButton("Mondo Chick: 00:00", function()
            api.tween(1, game:GetService("Workspace").FlowerZones["Mountain Top Field"].CFrame)
        end)

        -- Создаем раздел для утилит
        local panel2 = hometab:CreateSection("Utility Panel")

        -- Создаем кнопки для утилит
        local windUpd = panel2:CreateButton("Wind Shrine: 00:00", function()
            api.tween(1, CFrame.new(game:GetService("Workspace").NPCs["Wind Shrine"].Circle.Position + Vector3.new(0, 5, 0)))
        end)

        -- Создаем таблицу утилит с соответствующими кнопками
        local utilities = {
            ["Red Field Booster"] = rfbUpd;
            ["Blue Field Booster"] = bfbUpd;
            ["Field Booster"] = wfbUpd;
            ["Coconut Dispenser"] = cocoDispUpd;
            ["Instant Converter"] = ic1;
            ["Instant Converter B"] = ic2;
            ["Instant Converter C"] = ic3;
            ["Wealth Clock"] = wcUpd;
            ["Mythic Meteor Shower"] = mmsUpd;
        }

        -- Основной цикл для обновления информации в панели
        while wait(1) do
            if jeq.toggles.enablestatuspanel == true then
                -- Обновляем информацию о монстрах в панели
                for i, v in pairs(statusTable) do
                    if v[1] and v[2] then
                        v[1]:UpdateText(fetchVisualMonsterString(v[2]))
                    end
                end

                -- Обновляем информацию о Mondo Chick
                if workspace:FindFirstChild("Clock") then
                    if workspace.Clock:FindFirstChild("SurfaceGui") then
                        if workspace.Clock.SurfaceGui:FindFirstChild("TextLabel") then
                            if workspace.Clock.SurfaceGui:FindFirstChild("TextLabel").Text == "! ! !" then
                                mob2:UpdateText("Mondo Chick: Ready")
                            else
                                mob2:UpdateText("Mondo Chick: " .. string.gsub(
                                    string.gsub(workspace.Clock.SurfaceGui:FindFirstChild("TextLabel").Text, "\n", ""),
                                    "Mondo Chick:", ""))
                            end
                        end
                    end
                end

                -- Обновляем информацию о времени восстановления утилит
                local cooldown = require(game.ReplicatedStorage.TimeString)(3600 - (require(game.ReplicatedStorage.OsTime)() - (require(game.ReplicatedStorage.StatTools).GetLastCooldownTime(v1, "WindShrine") or 0)))
                if cooldown == "" then
                    windUpd:UpdateText("Wind Shrine: Ready")
                else
                    windUpd:UpdateText("Wind Shrine: " .. cooldown)
                end

                -- Обновляем информацию о времени восстановления и доступности других утилит
                for i, v in pairs(utilities) do
                    local cooldown, isUsable = getToyCooldown(i)
                    if cooldown ~= nil and isUsable ~= nil then
                        if isUsable then
                            v:UpdateText(i .. ": Ready")
                        else
                            v:UpdateText(i .. ": " .. require(game.ReplicatedStorage.TimeString)(cooldown))
                        end
                    end
                end
            end
        end
    end)
end)

