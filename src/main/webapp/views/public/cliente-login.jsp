<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Entrar — Muianga's</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=Montserrat:wght@300;400;500;600;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        *{box-sizing:border-box;margin:0;padding:0}
        body{font-family:'Montserrat',sans-serif;background:#0A0806;min-height:100vh;display:flex;overflow:hidden;}

        /* Lado esquerdo — imagem */
        .auth-visual{
            flex:1;position:relative;display:none;
        }
        @media(min-width:900px){.auth-visual{display:block;}}
        .auth-visual-bg{
            position:absolute;inset:0;
            background-image:url('${pageContext.request.contextPath}/imagens_site/fachada.jpeg');
            background-size:cover;background-position:center;
            filter:brightness(0.35) saturate(0.8);
        }
        .auth-visual-overlay{
            position:absolute;inset:0;
            background:linear-gradient(135deg,rgba(10,8,6,0.5) 0%,rgba(107,76,42,0.2) 100%);
        }
        .auth-visual-content{
            position:absolute;inset:0;
            display:flex;flex-direction:column;justify-content:flex-end;
            padding:3.5rem;
        }
        .auth-visual-brand{
            font-family:'Playfair Display',serif;
            font-size:3rem;font-weight:900;color:#fff;letter-spacing:4px;line-height:1;
        }
        .auth-visual-brand em{color:#C8A951;font-style:normal;}
        .auth-visual-sub{
            font-size:0.62rem;letter-spacing:5px;text-transform:uppercase;
            color:rgba(255,255,255,0.35);margin-top:0.6rem;
        }
        .auth-visual-line{
            width:50px;height:2px;
            background:linear-gradient(90deg,#C8A951,transparent);
            margin:1.5rem 0;
        }
        .auth-visual-quote{
            font-size:0.88rem;color:rgba(255,255,255,0.4);
            font-style:italic;line-height:1.7;max-width:320px;
            font-family:'Playfair Display',serif;
        }

        /* Lado direito — formulário */
        .auth-form-side{
            width:100%;max-width:480px;
            display:flex;flex-direction:column;justify-content:center;
            padding:3rem 3rem;background:#0E0C0A;
            overflow-y:auto;
        }
        @media(min-width:900px){.auth-form-side{padding:4rem 3.5rem;}}

        .auth-logo{margin-bottom:2.5rem;}
        .auth-logo-name{
            font-family:'Playfair Display',serif;
            font-size:1.4rem;font-weight:900;color:#C8A951;letter-spacing:3px;
        }
        .auth-logo-sub{font-size:0.58rem;letter-spacing:3px;text-transform:uppercase;color:#2A2218;margin-top:0.2rem;}

        .auth-titulo{font-size:1.6rem;font-weight:900;color:#F0EAE0;margin-bottom:0.4rem;line-height:1.2;}
        .auth-sub{font-size:0.78rem;color:#4A4038;margin-bottom:2rem;line-height:1.7;}

        /* Alerta redirect */
        .redirect-alert{
            background:rgba(200,169,81,0.06);border:1px solid rgba(200,169,81,0.2);
            border-radius:8px;padding:0.8rem 1rem;margin-bottom:1.5rem;
            display:flex;align-items:center;gap:0.7rem;
        }
        .redirect-alert svg{stroke:#C8A951;fill:none;stroke-width:2;stroke-linecap:round;flex-shrink:0;}
        .redirect-alert span{font-size:0.78rem;color:#C8A951;}

        .form-group{margin-bottom:1.2rem;}
        .form-label{display:block;font-size:0.62rem;font-weight:700;letter-spacing:2.5px;text-transform:uppercase;color:#4A4038;margin-bottom:0.5rem;}
        .form-control{
            width:100%;padding:0.85rem 1.1rem;
            background:#161210;border:1.5px solid #1E1814;
            border-radius:8px;color:#F0EAE0;
            font-family:'Montserrat',sans-serif;font-size:0.88rem;
            transition:border-color 0.2s,box-shadow 0.2s;outline:none;
        }
        .form-control:focus{border-color:#C8A951;box-shadow:0 0 0 3px rgba(200,169,81,0.08);}
        .form-control::placeholder{color:#2A2218;}

        .btn-submit{
            width:100%;padding:0.95rem;border-radius:50px;
            border:1.5px solid #C8A951;background:transparent;
            color:#C8A951;font-family:'Montserrat',sans-serif;
            font-size:0.75rem;font-weight:700;letter-spacing:2px;text-transform:uppercase;
            cursor:pointer;transition:all 0.25s;margin-top:0.5rem;
        }
        .btn-submit:hover{background:#C8A951;color:#0A0806;transform:translateY(-2px);box-shadow:0 8px 25px rgba(200,169,81,0.3);}

        .divider{display:flex;align-items:center;gap:1rem;margin:1.5rem 0;}
        .divider::before,.divider::after{content:'';flex:1;height:1px;background:#161210;}
        .divider span{font-size:0.6rem;color:#2A2218;letter-spacing:2px;text-transform:uppercase;}

        .btn-registo{
            width:100%;padding:0.9rem;border-radius:50px;
            border:1.5px solid #1E1814;background:transparent;
            color:#5A4E44;font-family:'Montserrat',sans-serif;
            font-size:0.72rem;font-weight:600;letter-spacing:1.5px;text-transform:uppercase;
            cursor:pointer;transition:all 0.2s;text-decoration:none;display:block;text-align:center;
        }
        .btn-registo:hover{border-color:#C8A951;color:#C8A951;}

        .auth-back{display:inline-flex;align-items:center;gap:0.4rem;font-size:0.7rem;color:#2A2218;text-decoration:none;margin-bottom:2rem;transition:color 0.2s;}
        .auth-back:hover{color:#C8A951;}
        .auth-back svg{stroke:currentColor;fill:none;stroke-width:2;stroke-linecap:round;}

        .alert-danger{background:rgba(138,58,42,0.12);border:1px solid rgba(138,58,42,0.3);color:#D06050;border-radius:8px;padding:0.8rem 1rem;margin-bottom:1.2rem;font-size:0.8rem;}
    </style>
</head>
<body>

<!-- Lado visual -->
<div class="auth-visual">
    <div class="auth-visual-bg"></div>
    <div class="auth-visual-overlay"></div>
    <div class="auth-visual-content">
        <div class="auth-visual-brand">MUIANGA<em>'S</em></div>
        <div class="auth-visual-sub">Bar &amp; Restaurante · Chimoio</div>
        <div class="auth-visual-line"></div>
        <div class="auth-visual-quote">"O sabor de Moçambique num ambiente único. Bem-vindo de volta."</div>
    </div>
</div>

<!-- Lado formulário -->
<div class="auth-form-side">
    <a href="${pageContext.request.contextPath}/" class="auth-back">
        <svg viewBox="0 0 24 24" width="14" height="14"><polyline points="15 18 9 12 15 6"/></svg>
        Voltar ao início
    </a>

    <div class="auth-logo">
        <div class="auth-logo-name">MUIANGA'S</div>
        <div class="auth-logo-sub">Bar &amp; Restaurante</div>
    </div>

    <div class="auth-titulo">Bem-vindo<br>de volta</div>
    <div class="auth-sub">Entra na tua conta para fazer pedidos, reservas e muito mais.</div>

    <c:if test="${not empty param.redirect}">
        <div class="redirect-alert">
            <svg viewBox="0 0 24 24" width="16" height="16"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0110 0v4"/></svg>
            <span>Faz login para continuar</span>
        </div>
    </c:if>
    <c:if test="${not empty erro}">
        <div class="alert-danger"><c:out value="${erro}"/></div>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}/cliente/login">
        <c:if test="${not empty param.redirect}">
            <input type="hidden" name="redirect" value="${param.redirect}">
        </c:if>
        <div class="form-group">
            <label class="form-label">E-mail</label>
            <input type="email" name="email" class="form-control" placeholder="o-teu@email.com" required autofocus>
        </div>
        <div class="form-group">
            <label class="form-label">Senha</label>
            <input type="password" name="senha" class="form-control" placeholder="••••••••" required>
        </div>
        <button type="submit" class="btn-submit">Entrar</button>
    </form>

    <div class="divider"><span>Novo por aqui?</span></div>

    <a href="${pageContext.request.contextPath}/cliente/registo${not empty param.redirect ? '?redirect='.concat(param.redirect) : ''}"
       class="btn-registo">Criar conta gratuita</a>
</div>
</body>
</html>
