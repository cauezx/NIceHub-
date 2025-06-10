-- CONFIGURAÇÕES
local targetGear = 4 -- Gear que será selecionado para farm
local racesToFarm = {"Cyborg", "Ghoul", "Race1", "Race2", "Race3", "Race4"} -- Raças para farm automático
local neededFragments = 1500 -- Fragmentos necessários para comprar próximo trem
local farming = true

-- FUNÇÕES BASE

-- Entrar no servidor Full Moon
function joinFullMoonServer()
    Kaitun.log("Entrando no servidor Full Moon...")
    Kaitun.joinServer("FullMoon")
    Kaitun.wait(5) -- Espera entrar no servidor
end

-- Selecionar Gear
function selectGear(gearNumber)
    Kaitun.log("Selecionando Gear "..gearNumber)
    Kaitun.selectGear(gearNumber)
    Kaitun.wait(2)
end

-- Farmar fragmentos até conseguir a quantidade necessária
function farmFragments()
    Kaitun.log("Iniciando farm de fragmentos...")
    while Kaitun.getFragments() < neededFragments and farming do
        Kaitun.farmFragment()
        Kaitun.wait(1)
    end
    Kaitun.log("Farm de fragmentos finalizado. Frags: "..Kaitun.getFragments())
end

-- Farmar as raças
function farmAllRaces()
    Kaitun.log("Iniciando farm das raças...")
    for _, race in ipairs(racesToFarm) do
        if not farming then break end
        Kaitun.log("Farmando raça: "..race)
        Kaitun.selectRace(race)
        Kaitun.startRace()
        Kaitun.waitUntilRaceComplete()
        Kaitun.collectRewards()
        Kaitun.wait(2)
    end
    Kaitun.log("Farm das raças concluído.")
end

-- Comprar Cyborg e Ghoul
function buyCyborgAndGhoul()
    Kaitun.log("Tentando comprar Cyborg e Ghoul...")
    if Kaitun.canBuy("Cyborg") then
        Kaitun.buy("Cyborg")
        Kaitun.wait(1)
    end
    if Kaitun.canBuy("Ghoul") then
        Kaitun.buy("Ghoul")
        Kaitun.wait(1)
    end
end

-- Upgrade Raças V1~V3
function upgradeRacesV1toV3()
    Kaitun.log("Fazendo upgrade das Raças V1~V3...")
    for v=1,3 do
        local raceName = "V"..v
        if Kaitun.canUpgrade(raceName) then
            Kaitun.upgradeRace(raceName)
            Kaitun.wait(1)
        end
    end
end

-- Parar farm quando completar trials e trains
function checkStopFarm()
    if Kaitun.allTrialsDone() and Kaitun.allTrainsDone() then
        Kaitun.log("Trials e Trains finalizados, parando farm...")
        farming = false
        Kaitun.stopFarm()
    end
end

-- Função principal
function main()
    joinFullMoonServer()
    selectGear(targetGear)

    while farming do
        farmFragments()
        farmAllRaces()
        buyCyborgAndGhoul()
        upgradeRacesV1toV3()
        checkStopFarm()
        Kaitun.wait(5)
    end

    Kaitun.log("Script finalizado.")
end

-- Iniciar script
main()
