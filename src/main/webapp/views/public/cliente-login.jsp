<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Entrar — Muianga's</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body { padding-top:70px; background:#0E0C0A; min-height:100vh; display:flex; flex-direction:column; }
        .auth-wrap { flex:1; display:flex; align-items:center; justify-content:center; padding:3rem 1rem; }
        .auth-box  { background:#161210; border:1px solid #1E1814; border-radius:12px; padding:2.5rem; width:100%; max-width:420px; }
        .auth-logo { text-align:center; margin-bottom:2rem; }
        .auth-logo .marca { font-size:1.2rem; font-weight:900; letter-spacing:4px; color:#C8A951; }
        .auth-logo .sub   { font-size:0.6rem; letter-spacing:3px; text-transform:uppercase; color:#3A3028; margin-top:0.3rem; }
        .auth-titulo { font-size:1.3rem; font-weight:900; color:#F0EAE0; margin-bottom:0.3rem; }
        .auth-sub    { font-size:0.78rem; color:#4A4038; margin-bottom:1.8rem; }
        .auth-footer { text-align:center; margin-top:1.5rem; font-size:0.78rem; color:#4A4038; }
        .auth-footer a { color:#C8A951; text-decoration:none; font-weight:600; }
        .auth-footer a:hover { text-decoration:underline; }
        .divider { display:flex; align-items:center; gap:1rem; margin:1.2rem 0; }
        .divider::before,.divider::after { content:''; flex:1; height:1px; background:#1E1814; }
        .divider span { font-size:0.65rem; color:#3A3028; letter-spacing:1px; text-transform:uppercase; }
        .btn-voltar { display:inline-flex; align-items:center; gap:0.4rem; font-size:0.72rem; color:#4A4038; text-decoration:none; margin-bottom:1.5rem; }
        .btn-voltar:hover { color:#C8A951; }
    </style>
</head>
<body>
<nav class="navbar">
    <div class="navbar-brand">MUIANGA'S <span>Bar &amp; Restaurante</span></div>
    <ul class="navbar-nav">
        <li><a href="${pageContext.request.contextPath}/views/public/index.jsp">Início</a></li>
        <li><a href="${pageContext.request.contextPath}/menu">Menu</a></li>
        <li><a href="${pageContext.request.contextPath}/delivery">Delivery</a></li>
    </ul>
</nav>

<div class="auth-wrap">
    <div class="auth-box">
        <a href="${pageContext.request.contextPath}/views/public/index.jsp" class="btn-voltar">← Voltar ao início</a>

        <div class="auth-logo">
            <div class="marca">MUIANGA'S</div>
            <div class="sub">Bar &amp; Restaurante</div>
        </div>

        <div class="auth-titulo">Bem-vindo de volta</div>
        <div class="auth-sub">Entra na tua conta para acompanhar os teus pedidos</div>

        <c:if test="${not empty erro}">
            <div class="alert alert-danger" style="margin-bottom:1.2rem;font-size:0.82rem;">
                ⚠️ <c:out value="${erro}"/>
            </div>
        </c:if>
        <c:if test="${not empty param.redirect}">
            <div class="alert" style="background:rgba(200,169,81,0.08);border:1px solid rgba(200,169,81,0.2);color:#C8A951;border-radius:6px;padding:0.7rem 1rem;margin-bottom:1.2rem;font-size:0.78rem;">
                🔒 Faz login para continuar
            </div>
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
                <input type="password" name="senha" class="form-control" placeholder="••••••" required>
            </div>
            <button type="submit" class="btn btn-gold" style="width:100%;margin-top:0.5rem;">
                Entrar
            </button>
        </form>

        <div class="divider"><span>ou</span></div>

        <a href="${pageContext.request.contextPath}/cliente/registo"
           class="btn btn-outline" style="width:100%;text-align:center;display:block;">
            Criar conta gratuita
        </a>


    </div>
</div>

<footer>
    <strong>MUIANGA'S</strong> Bar &amp; Restaurante · &copy; 2026
</footer>
</body>
</html>
