<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <title>Mesas — Muianga's</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<%@ include file="sidebar.jspf" %>

<div class="page-header">
    <div>
        <h1 class="page-title">Mesas</h1>
        <p class="page-subtitle">Estado em tempo real</p>
    </div>
    <a href="${pageContext.request.contextPath}/admin/mesas?acao=nova" class="btn btn-gold">+ Nova Mesa</a>
</div>

<c:if test="${not empty erro}">
    <div class="alert alert-danger"><c:out value="${erro}"/></div>
</c:if>

<div class="flex gap-2 mb-3">
    <span class="badge badge-success">🟢 Livre</span>
    <span class="badge badge-danger">🔴 Ocupada</span>
    <span class="badge badge-warning">🟡 Reservada</span>
</div>

<div class="grid-4">
    <c:forEach var="m" items="${mesas}">
    <div class="mesa-card ${m.status}">
        <div class="mesa-numero">Mesa ${m.numero}</div>
        <div class="text-muted" style="font-size:0.8rem;">${m.capacidade} lugares</div>
        <div class="mesa-status ${m.status}">${m.status}</div>
        <div class="flex gap-1 mt-2 justify-between" style="flex-wrap:wrap;">
            <a href="${pageContext.request.contextPath}/admin/mesas?acao=editar&id=${m.id}"
               class="btn btn-outline btn-sm">Editar</a>
            <select onchange="location.href='${pageContext.request.contextPath}/admin/mesas?acao=status&id=${m.id}&s='+this.value"
                style="background:var(--bg-secondary);color:var(--text-muted);border:1px solid var(--border);
                       border-radius:4px;padding:0.3rem;font-size:0.75rem;cursor:pointer;">
                <option value="${m.status}" selected>Estado</option>
                <option value="livre">Livre</option>
                <option value="ocupada">Ocupada</option>
                <option value="reservada">Reservada</option>
            </select>
        </div>
    </div>
    </c:forEach>
</div>

</div><%-- fecha main-content --%>
</div><%-- fecha layout --%>

</body>
</html>
