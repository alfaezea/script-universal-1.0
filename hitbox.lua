-- Carregar o módulo da Hitbox e garantir que ele seja armazenado corretamente
local HitboxModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/alfaezea/script-universal-1.0/refs/heads/main/hitbox.lua"))()
-- O módulo retorna uma função construtora. Vamos verificar se ele foi carregado.
if not HitboxModule then
    warn("❌ Falha crítica: Módulo Hitbox não carregou. Verifique o link.")
else
    print("✅ Módulo Hitbox carregado com sucesso.")
end
