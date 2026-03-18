<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Criar Conta — Muianga's</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body { padding-top:70px; background:#0E0C0A; min-height:100vh; display:flex; flex-direction:column; }
        .auth-wrap { flex:1; display:flex; align-items:center; justify-content:center; padding:3rem 1rem; }
        .auth-box  { background:#161210; border:1px solid #1E1814; border-radius:12px; padding:2.5rem; width:100%; max-width:440px; }
        .auth-logo { text-align:center; margin-bottom:2rem; }
        .auth-logo .marca { font-size:1.2rem; font-weight:900; letter-spacing:4px; color:#C8A951; }
        .auth-logo .sub   { font-size:0.6rem; letter-spacing:3px; text-transform:uppercase; color:#3A3028; margin-top:0.3rem; }
        .auth-titulo { font-size:1.3rem; font-weight:900; color:#F0EAE0; margin-bottom:0.3rem; }
        .auth-sub    { font-size:0.78rem; color:#4A4038; margin-bottom:1.8rem; }
        .auth-footer { text-align:center; margin-top:1.5rem; font-size:0.78rem; color:#4A4038; }
        .auth-footer a { color:#C8A951; text-decoration:none; font-weight:600; }
        .vantagens { background:#120F0C; border-radius:8px; padding:1rem 1.2rem; margin-bottom:1.5rem; }
        .vantagem  { display:flex; align-items:center; gap:0.6rem; font-size:0.75rem; color:#5A4E44; padding:0.25rem 0; }
        .vantagem span:first-child { font-size:0.9rem; }
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
        <a href="${pageContext.request.contextPath}/cliente/login" class="btn-voltar">← Voltar ao login</a>

        <div class="auth-logo">
            <div class="marca">MUIANGA'S</div>
            <div class="sub">Bar &amp; Restaurante</div>
        </div>

        <div class="auth-titulo">Criar conta gratuita</div>
        <div class="auth-sub">Junta-te e desfruta de vantagens exclusivas</div>

        <div class="vantagens">
            <div class="vantagem"><span>📋</span> Histórico de todos os teus pedidos</div>
            <div class="vantagem"><span>📍</span> Endereços guardados para entrega rápida</div>
            <div class="vantagem"><span>❤️</span> Guarda os teus pratos favoritos</div>
            <div class="vantagem"><span>🔄</span> Acompanha o estado do pedido em tempo real</div>
            <div class="vantagem"><span>⭐</span> Deixa avaliações e ajuda outros clientes</div>
        </div>

        <c:if test="${not empty erro}">
            <div class="alert alert-danger" style="margin-bottom:1.2rem;font-size:0.82rem;">
                ⚠️ <c:out value="${erro}"/>
            </div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/cliente/registo">
            <div class="form-group">
                <label class="form-label">Nome completo *</label>
                <input type="text" name="nome" class="form-control" placeholder="O teu nome" required autofocus>
            </div>
            <div class="form-group">
                <label class="form-label">E-mail *</label>
                <input type="email" name="email" class="form-control" placeholder="o-teu@email.com" required>
            </div>
            <div class="form-group">
                <label class="form-label">Telefone</label>
                <input type="tel" name="telefone" class="form-control" placeholder="+258 84 000 0000">
            </div>
            <div class="form-group">
                <label class="form-label">Senha * <span style="color:#3A3028;font-size:0.65rem;">(mínimo 6 caracteres)</span></label>
                <input type="password" name="senha" class="form-control" placeholder="••••••" required minlength="6">
            </div>
            <div class="form-group">
                <label class="form-label">Confirmar senha *</label>
                <input type="password" name="confirma" class="form-control" placeholder="••••••" required>
            </div>
            <button type="submit" class="btn btn-gold" style="width:100%;margin-top:0.5rem;">
                Criar conta
            </button>
        </form>

        <div class="auth-footer">
            Já tens conta?
            <a href="${pageContext.request.contextPath}/cliente/login">Entrar →</a>
        </div>
    </div>
</div>

<footer>
    <strong>MUIANGA'S</strong> Bar &amp; Restaurante · &copy; 2026
</footer>
</body>
</html>
