<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <title>Login — Muianga's</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        /* Sem indicação visual de que é área admin */
        .login-hint { display:none; }
    </style>
</head>
<body>
<div class="login-page">
    <div class="login-card">
        <div class="login-logo">
            <h1>MUIANGA'S</h1>
            <p>Área Interna · Autenticação</p>
        </div>

        <c:if test="${not empty erro}">
            <div class="alert alert-danger"><c:out value="${erro}"/></div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/login">
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
            <a href="${pageContext.request.contextPath}/views/public/index.jsp">← Voltar ao site</a>
        </p>
    </div>
</div>
</body>
</html>
