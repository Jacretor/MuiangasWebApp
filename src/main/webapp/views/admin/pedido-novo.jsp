<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <title>Novo Pedido — Muianga's</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<%@ include file="sidebar.jspf" %>

<div class="page-header">
    <h1 class="page-title">Novo Pedido</h1>
    <a href="${pageContext.request.contextPath}/admin/pedidos" class="btn btn-outline">← Voltar</a>
</div>

<c:if test="${not empty erro}"><div class="alert alert-danger"><c:out value="${erro}"/></div></c:if>

<div style="max-width:600px;">
<div class="card">
<form method="post" action="${pageContext.request.contextPath}/admin/pedidos?acao=novo">
    <div class="form-group">
        <label class="form-label">Mesa *</label>
        <select name="mesaId" class="form-control" required>
            <option value="">Seleccione uma mesa livre</option>
            <c:forEach var="m" items="${mesasLivres}">
                <option value="${m.id}">Mesa ${m.numero} (${m.capacidade} lugares)</option>
            </c:forEach>
        </select>
        <c:if test="${empty mesasLivres}">
            <p class="text-danger" style="font-size:0.85rem;margin-top:0.3rem;">Nenhuma mesa disponível.</p>
        </c:if>
    </div>

    <hr style="border-color:var(--border);margin:1rem 0;">
    <p class="text-muted mb-2" style="font-size:0.85rem;">Cliente existente ou novo:</p>

    <div class="form-group">
        <label class="form-label">Seleccionar Cliente Existente</label>
        <select name="clienteId" class="form-control">
            <option value="0">— Novo cliente —</option>
            <c:forEach var="c" items="${clientes}">
                <option value="${c.id}"><c:out value="${c.nome}"/> — <c:out value="${c.telefone}"/></option>
            </c:forEach>
        </select>
    </div>

    <div class="grid-2">
        <div class="form-group">
            <label class="form-label">Nome do Cliente</label>
            <input type="text" name="clienteNome" class="form-control" placeholder="(se novo)">
        </div>
        <div class="form-group">
            <label class="form-label">Telefone</label>
            <input type="text" name="clienteTelefone" class="form-control" placeholder="+258...">
        </div>
    </div>

    <div class="flex gap-1 mt-2">
        <button type="submit" class="btn btn-gold">Criar Pedido</button>
        <a href="${pageContext.request.contextPath}/admin/pedidos" class="btn btn-outline">Cancelar</a>
    </div>
</form>
</div>
</div>

</div></div>
</body>
</html>
