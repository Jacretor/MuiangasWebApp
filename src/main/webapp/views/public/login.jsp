<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login — Muianga's</title>
    <link rel="stylesheet" href="/MuiangasWeb/css/style.css">
</head>
<body>
<div class="login-page">
    <div class="login-card">
        <div class="login-logo">
            <h1>MUIANGA'S</h1>
            <p>Área Interna · Autenticação</p>
        </div>

        <div id="msg-erro" class="alert alert-danger" style="display:none;"></div>

        <form method="post" action="/MuiangasWeb/login">
            <div class="form-group">
                <label class="form-label">E-mail</label>
                <input type="email" name="email" class="form-control"
                       placeholder="funcionario@muiangas.mz" required autofocus>
            </div>
            <div class="form-group">
                <label class="form-label">Senha</label>
                <input type="password" name="senha" class="form-control"
                       placeholder="••••••••" required>
            </div>
            <button type="submit" class="btn btn-gold w-100 mt-2">Entrar</button>
        </form>

        <p class="text-center text-muted mt-3" style="font-size:0.8rem;">
            <a href="/MuiangasWeb/">← Voltar ao site</a>
        </p>
    </div>
</div>

<script>
    // Mostrar erro se vier via parâmetro URL (?erro=...)
    var params = new URLSearchParams(window.location.search);
    var erro   = params.get('erro');
    if (erro) {
        var el = document.getElementById('msg-erro');
        var msgs = {
            'credenciais': 'E-mail ou senha inválidos.',
            'campos':      'Preencha o e-mail e a senha.',
            'interno':     'Erro interno. Tente novamente.'
        };
        el.textContent = msgs[erro] || 'Erro ao autenticar.';
        el.style.display = 'block';
    }
</script>
</body>
</html>
