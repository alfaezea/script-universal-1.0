-- Aimbot Mínimo para Teste
local AimbotSimples = {
    Enabled = false,
    Versao = "1.0"
}

function AimbotSimples:Ativar()
    self.Enabled = true
    print("✅ Aimbot ativado!")
end

function AimbotSimples:Desativar()
    self.Enabled = false
    print("❌ Aimbot desativado!")
end

print("✅ Módulo Aimbot de teste carregado!")
return AimbotSimples
