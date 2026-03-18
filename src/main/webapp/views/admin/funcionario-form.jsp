<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="pt"><head><meta charset="UTF-8"><title>Funcionário — Muianga's</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body>
<%@ include file="sidebar.jspf" %>
<div class="page-header">
    <h1 class="page-title">${empty funcionario.id || funcionario.id == 0 ? 'Novo Funcionário' : 'Editar Funcionário'}</h1>
    <a href="${pageContext.request.contextPath}/admin/funcionarios" class="btn btn-outline">← Voltar</a>
</div>
<div style="max-width:500px;">
<div class="card">
<form method="post" action="${pageContext.request.contextPath}/admin/funcionarios">
    <input type="hidden" name="id" value="${funcionario.id}">
    <div class="form-group">
        <label class="form-label">Nome *</label>
        <input type="text" name="nome" class="form-control" value="<c:out value='${funcionario.nome}'/>" required>
    </div>
    <div class="form-group">
        <label class="form-label">E-mail *</label>
        <input type="email" name="email" class="form-control" value="<c:out value='${funcionario.email}'/>" required>
    </div>
    <div class="form-group">
        <label class="form-label">Senha ${funcionario.id > 0 ? '(deixar em branco para manter)' : '*'}</label>
        <input type="password" name="senha" class="form-control" ${funcionario.id == 0 ? 'required' : ''} placeholder="••••••••">
    </div>
    <div class="form-group">
        <label class="form-label">Cargo *</label>
        <select name="cargo" class="form-control" required>
            <option value="funcionario" ${funcionario.cargo == 'funcionario' ? 'selected' : ''}>Funcionário</option>
            <option value="admin" ${funcionario.cargo == 'admin' ? 'selected' : ''}>Administrador</option>
        </select>
    </div>
    <button type="submit" class="btn btn-gold">Guardar</button>
</form>
</div>
</div>
</div></div>
</body></html>
