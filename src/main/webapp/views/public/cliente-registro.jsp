<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Criar Conta — Muianga's</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=Montserrat:wght@300;400;500;600;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        *{box-sizing:border-box;margin:0;padding:0}
        body{font-family:'Montserrat',sans-serif;background:#0A0806;min-height:100vh;display:flex;overflow-x:hidden;}

        .auth-visual{flex:1;position:relative;display:none;}
        @media(min-width:900px){.auth-visual{display:block;}}
        .auth-visual-bg{
            position:absolute;inset:0;
            background-image:url('${pageContext.request.contextPath}/imagens_site/fachada.jpeg');
            background-size:cover;background-position:center;
            filter:brightness(0.3) saturate(0.7);
        }
        .auth-visual-overlay{position:absolute;inset:0;background:linear-gradient(180deg,rgba(10,8,6,0.3) 0%,rgba(107,76,42,0.3) 100%);}
        .auth-visual-content{position:absolute;inset:0;display:flex;flex-direction:column;justify-content:center;padding:3.5rem;}
        .auth-visual-brand{font-family:'Playfair Display',serif;font-size:2.8rem;font-weight:900;color:#fff;letter-spacing:3px;line-height:1;}
        .auth-visual-brand em{color:#C8A951;font-style:normal;}
        .auth-visual-line{width:50px;height:2px;background:linear-gradient(90deg,#C8A951,transparent);margin:1.5rem 0;}
        .auth-visual-perks{display:flex;flex-direction:column;gap:1rem;}
        .perk{display:flex;align-items:center;gap:1rem;}
        .perk-icon{
            width:40px;height:40px;border-radius:10px;flex-shrink:0;
            background:rgba(200,169,81,0.1);border:1px solid rgba(200,169,81,0.2);
            display:flex;align-items:center;justify-content:center;
        }
        .perk-icon svg{stroke:#C8A951;fill:none;stroke-width:1.8;stroke-linecap:round;stroke-linejoin:round;}
        .perk-txt{font-size:0.78rem;color:rgba(255,255,255,0.5);line-height:1.4;}
        .perk-txt strong{color:rgba(255,255,255,0.75);display:block;margin-bottom:0.1rem;}

        .auth-form-side{
            width:100%;max-width:500px;
            display:flex;flex-direction:column;justify-content:center;
            padding:3rem 2.5rem;background:#0E0C0A;overflow-y:auto;
        }
        @media(min-width:900px){.auth-form-side{padding:3rem 3.5rem;}}

        .auth-logo{margin-bottom:2rem;}
        .auth-logo-name{font-family:'Playfair Display',serif;font-size:1.3rem;font-weight:900;color:#C8A951;letter-spacing:3px;}
        .auth-logo-sub{font-size:0.58rem;letter-spacing:3px;text-transform:uppercase;color:#2A2218;margin-top:0.2rem;}
        .auth-titulo{font-size:1.5rem;font-weight:900;color:#F0EAE0;margin-bottom:0.4rem;}
        .auth-sub{font-size:0.78rem;color:#4A4038;margin-bottom:1.8rem;}

        .form-group{margin-bottom:1rem;}
        .form-label{display:block;font-size:0.6rem;font-weight:700;letter-spacing:2.5px;text-transform:uppercase;color:#4A4038;margin-bottom:0.45rem;}
        .form-control{
            width:100%;padding:0.8rem 1rem;
            background:#161210;border:1.5px solid #1E1814;
            border-radius:8px;color:#F0EAE0;
            font-family:'Montserrat',sans-serif;font-size:0.85rem;
            transition:border-color 0.2s,box-shadow 0.2s;outline:none;
        }
        .form-control:focus{border-color:#C8A951;box-shadow:0 0 0 3px rgba(200,169,81,0.08);}
        .form-control::placeholder{color:#2A2218;}
        .grid-2{display:grid;grid-template-columns:1fr 1fr;gap:1rem;}

        .btn-submit{
            width:100%;padding:0.9rem;border-radius:50px;
            border:1.5px solid #C8A951;background:transparent;
            color:#C8A951;font-family:'Montserrat',sans-serif;
            font-size:0.72rem;font-weight:700;letter-spacing:2px;text-transform:uppercase;
            cursor:pointer;transition:all 0.25s;margin-top:0.5rem;
        }
        .btn-submit:hover{background:#C8A951;color:#0A0806;transform:translateY(-2px);box-shadow:0 8px 25px rgba(200,169,81,0.3);}

        .auth-footer{text-align:center;margin-top:1.2rem;font-size:0.75rem;color:#3A3028;}
        .auth-footer a{color:#C8A951;text-decoration:none;font-weight:600;}
        .auth-footer a:hover{text-decoration:underline;}
        .auth-back{display:inline-flex;align-items:center;gap:0.4rem;font-size:0.7rem;color:#2A2218;text-decoration:none;margin-bottom:2rem;transition:color 0.2s;}
        .auth-back:hover{color:#C8A951;}
        .auth-back svg{stroke:currentColor;fill:none;stroke-width:2;stroke-linecap:round;}
        .alert-danger{background:rgba(138,58,42,0.12);border:1px solid rgba(138,58,42,0.3);color:#D06050;border-radius:8px;padding:0.8rem 1rem;margin-bottom:1.2rem;font-size:0.8rem;}

        .hint{font-size:0.62rem;color:#2A2218;margin-top:0.3rem;}
        @media(max-width:500px){.grid-2{grid-template-columns:1fr;}}
    </style>
</head>
<body>

<!-- Lado visual com vantagens -->
<div class="auth-visual">
    <div class="auth-visual-bg"></div>
    <div class="auth-visual-overlay"></div>
    <div class="auth-visual-content">
        <div class="auth-visual-brand">MUIANGA<em>'S</em></div>
        <div class="auth-visual-line"></div>
        <div class="auth-visual-perks">
            <div class="perk">
                <div class="perk-icon">
                    <svg viewBox="0 0 24 24" width="18" height="18"><path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
                </div>
                <div class="perk-txt"><strong>Histórico de pedidos</strong>Acompanha todos os teus pedidos</div>
            </div>
            <div class="perk">
                <div class="perk-icon">
                    <svg viewBox="0 0 24 24" width="18" height="18"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/></svg>
                </div>
                <div class="perk-txt"><strong>Endereços guardados</strong>Entrega rápida sem reescrever</div>
            </div>
            <div class="perk">
                <div class="perk-icon">
                    <svg viewBox="0 0 24 24" width="18" height="18"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 000-7.78z"/></svg>
                </div>
                <div class="perk-txt"><strong>Favoritos &amp; Reservas</strong>Guarda pratos e faz reservas online</div>
            </div>
            <div class="perk">
                <div class="perk-icon">
                    <svg viewBox="0 0 24 24" width="18" height="18"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
                </div>
                <div class="perk-txt"><strong>Avaliações</strong>Deixa a tua opinião e ajuda outros</div>
            </div>
        </div>
    </div>
</div>

<!-- Formulário -->
<div class="auth-form-side">
    <a href="${pageContext.request.contextPath}/cliente/login" class="auth-back">
        <svg viewBox="0 0 24 24" width="14" height="14"><polyline points="15 18 9 12 15 6"/></svg>
        Já tenho conta
    </a>

    <div class="auth-logo">
        <div class="auth-logo-name">MUIANGA'S</div>
        <div class="auth-logo-sub">Criar conta gratuita</div>
    </div>

    <div class="auth-titulo">Junta-te a nós</div>
    <div class="auth-sub">Cria a tua conta e começa a fazer pedidos e reservas online.</div>

    <c:if test="${not empty erro}">
        <div class="alert-danger"><c:out value="${erro}"/></div>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}/cliente/registo">
        <c:if test="${not empty param.redirect}">
            <input type="hidden" name="redirect" value="${param.redirect}">
        </c:if>
        <div class="form-group">
            <label class="form-label">Nome completo *</label>
            <input type="text" name="nome" class="form-control" placeholder="O teu nome completo" required autofocus>
        </div>
        <div class="form-group">
            <label class="form-label">E-mail *</label>
            <input type="email" name="email" class="form-control" placeholder="o-teu@email.com" required>
        </div>
        <div class="form-group">
            <label class="form-label">Telefone (WhatsApp)</label>
            <input type="tel" name="telefone" class="form-control" placeholder="+258 84 000 0000">
            <div class="hint">Usado para confirmar reservas e pedidos</div>
        </div>
        <div class="grid-2">
            <div class="form-group">
                <label class="form-label">Senha *</label>
                <input type="password" name="senha" class="form-control" placeholder="••••••" required minlength="6">
                <div class="hint">Mínimo 6 caracteres</div>
            </div>
            <div class="form-group">
                <label class="form-label">Confirmar *</label>
                <input type="password" name="confirma" class="form-control" placeholder="••••••" required>
            </div>
        </div>
        <button type="submit" class="btn-submit">Criar conta</button>
    </form>

    <div class="auth-footer">
        Já tens conta? <a href="${pageContext.request.contextPath}/cliente/login">Entrar →</a>
    </div>
</div>
</body>
</html>
