-- ESP Mínimo para Teste
local ESPsimples = {
    Enabled = false,
    Versao = "1.0"
}

function ESPsimples:Ativar()
    self.Enabled = true
    print("✅ ESP ativado!")
end

function ESPsimples:Desativar()
    self.Enabled = false
    print("❌ ESP desativado!")
end

print("✅ Módulo ESP de teste carregado!")
return ESPsimples
