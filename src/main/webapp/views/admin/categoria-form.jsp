<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="pt"><head><meta charset="UTF-8"><title>Categoria — Muianga's</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body>
<%@ include file="sidebar.jspf" %>
<div class="page-header">
    <h1 class="page-title">${empty categoria.id || categoria.id == 0 ? 'Nova Categoria' : 'Editar Categoria'}</h1>
    <a href="${pageContext.request.contextPath}/admin/categorias" class="btn btn-outline">← Voltar</a>
</div>
<div style="max-width:500px;">
<div class="card">
<form method="post" action="${pageContext.request.contextPath}/admin/categorias">
    <input type="hidden" name="id" value="${categoria.id}">
    <div class="form-group">
        <label class="form-label">Nome *</label>
        <input type="text" name="nome" class="form-control" value="<c:out value='${categoria.nome}'/>" required>
    </div>
    <div class="form-group">
        <label class="form-label">Descrição</label>
        <textarea name="descricao" class="form-control"><c:out value="${categoria.descricao}"/></textarea>
    </div>
    <button type="submit" class="btn btn-gold">Guardar</button>
</form>
</div>
</div>
</div></div>
</body></html>
