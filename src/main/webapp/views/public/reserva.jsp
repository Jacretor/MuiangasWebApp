<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reserva de Mesa — Muianga's</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<nav class="navbar">
    <div class="navbar-brand">MUIANGA'S <span>Bar &amp; Restaurante</span></div>
    <ul class="navbar-nav">
        <li><a href="${pageContext.request.contextPath}/views/public/index.jsp">Início</a></li>
        <li><a href="${pageContext.request.contextPath}/views/public/menu.jsp">Menu</a></li>
        <li><a href="${pageContext.request.contextPath}/views/public/reserva.jsp" class="active">Reserva</a></li>
        <c:choose>
            <c:when test="${not empty sessionScope.cliente}">
                <li><a href="${pageContext.request.contextPath}/cliente/area" class="btn btn-outline btn-sm">👤 ${sessionScope.cliente.nome}</a></li>
            </c:when>
            <c:otherwise>
                <li><a href="${pageContext.request.contextPath}/cliente/login" class="btn btn-outline btn-sm">Entrar</a></li>
            </c:otherwise>
        </c:choose>
    </ul>
</nav>

<div class="container-sm" style="padding-top: 7rem; padding-bottom: 4rem;">
    <div class="card">
        <h2 class="text-gold mb-1" style="font-size:1.5rem;font-weight:900;">Reservar uma Mesa</h2>
        <p class="text-muted mb-3">Preencha os dados abaixo e entraremos em contacto para confirmar a sua reserva.</p>

        <c:if test="${not empty sucesso}">
            <div class="alert alert-success"><c:out value="${sucesso}"/></div>
        </c:if>
        <c:if test="${not empty erro}">
            <div class="alert alert-danger"><c:out value="${erro}"/></div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/reserva">
            <div class="form-group">
                <label class="form-label">Nome Completo *</label>
                <input type="text" name="nome" class="form-control" required placeholder="O seu nome">
            </div>
            <div class="form-group">
                <label class="form-label">Telefone *</label>
                <input type="tel" name="telefone" class="form-control" required placeholder="+258 84 000 0000">
            </div>
            <div class="grid-2">
                <div class="form-group">
                    <label class="form-label">Data *</label>
                    <input type="date" name="data" class="form-control" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Hora *</label>
                    <input type="time" name="hora" class="form-control" required>
                </div>
            </div>
            <div class="form-group">
                <label class="form-label">Número de Pessoas *</label>
                <select name="pessoas" class="form-control" required>
                    <option value="">Seleccione</option>
                    <c:forEach var="i" begin="1" end="20">
                        <option value="${i}">${i} pessoa${i > 1 ? 's' : ''}</option>
                    </c:forEach>
                </select>
            </div>
            <button type="submit" class="btn btn-gold w-100">Confirmar Reserva</button>
        </form>
    </div>
</div>

<footer>
    <strong>MUIANGA'S</strong> Bar &amp; Restaurante · Chimoio, Manica, Moçambique · &copy; 2026
</footer>
</body>
</html>
