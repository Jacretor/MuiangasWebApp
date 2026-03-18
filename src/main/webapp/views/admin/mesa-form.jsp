<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="pt"><head><meta charset="UTF-8"><title>Mesa — Muianga's</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body>
<%@ include file="sidebar.jspf" %>
<div class="page-header">
    <h1 class="page-title">${empty mesa.id || mesa.id == 0 ? 'Nova Mesa' : 'Editar Mesa'}</h1>
    <a href="${pageContext.request.contextPath}/admin/mesas" class="btn btn-outline">← Voltar</a>
</div>
<div style="max-width:400px;">
<div class="card">
<form method="post" action="${pageContext.request.contextPath}/admin/mesas">
    <input type="hidden" name="id" value="${mesa.id}">
    <div class="form-group">
        <label class="form-label">Número da Mesa *</label>
        <input type="number" name="numero" class="form-control" value="${mesa.numero}" min="1" required>
    </div>
    <div class="form-group">
        <label class="form-label">Capacidade (lugares) *</label>
        <input type="number" name="capacidade" class="form-control" value="${mesa.capacidade}" min="1" required>
    </div>
    <div class="form-group">
        <label class="form-label">Status</label>
        <select name="status" class="form-control">
            <option value="livre" ${mesa.status == 'livre' ? 'selected' : ''}>Livre</option>
            <option value="ocupada" ${mesa.status == 'ocupada' ? 'selected' : ''}>Ocupada</option>
            <option value="reservada" ${mesa.status == 'reservada' ? 'selected' : ''}>Reservada</option>
        </select>
    </div>
    <button type="submit" class="btn btn-gold">Guardar</button>
</form>
</div>
</div>
</div></div>
</body></html>
