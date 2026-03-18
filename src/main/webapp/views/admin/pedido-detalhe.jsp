<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <title>Pedido #${pedido.id} — Muianga's</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<%@ include file="sidebar.jspf" %>

<div class="page-header">
    <div>
        <h1 class="page-title">Pedido #${pedido.id}</h1>
        <p class="page-subtitle">Mesa ${pedido.mesaNumero} · <c:out value="${pedido.clienteNome}"/></p>
    </div>
    <div class="flex gap-1">
        <a href="${pageContext.request.contextPath}/admin/pedidos" class="btn btn-outline">← Voltar</a>
        <c:if test="${pedido.status == 'aberto'}">
            <a href="${pageContext.request.contextPath}/admin/pedidos?acao=fechar&id=${pedido.id}"
               class="btn btn-success"
               onclick="return confirm('Fechar pedido e registar pagamento?')">
               ✓ Fechar / Pagar
            </a>
        </c:if>
    </div>
</div>

<div class="grid-2">
    <!-- Itens do pedido -->
    <div class="card">
        <div class="card-title">Itens do Pedido</div>
        <table>
            <thead><tr><th>Produto</th><th>Qtd</th><th>Preço Unit.</th><th>Subtotal</th></tr></thead>
            <tbody>
                <c:forEach var="item" items="${pedido.itens}">
                <tr>
                    <td><c:out value="${item.produtoNome}"/></td>
                    <td>${item.quantidade}</td>
                    <td><fmt:formatNumber value="${item.precoUnitario}" pattern="#,##0.00"/></td>
                    <td class="text-gold"><fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00"/></td>
                </tr>
                </c:forEach>
                <c:if test="${empty pedido.itens}">
                <tr><td colspan="4" class="text-center text-muted">Sem itens. Adicione abaixo.</td></tr>
                </c:if>
            </tbody>
            <tfoot>
                <tr style="border-top:2px solid var(--accent);">
                    <td colspan="3" class="text-right"><strong class="text-gold">TOTAL:</strong></td>
                    <td><strong class="text-gold" style="font-size:1.2rem;">
                        <fmt:formatNumber value="${pedido.total}" pattern="#,##0.00"/> MZN
                    </strong></td>
                </tr>
            </tfoot>
        </table>
    </div>

    <!-- Adicionar item -->
    <c:if test="${pedido.status == 'aberto'}">
    <div class="card">
        <div class="card-title">Adicionar Item</div>
        <form method="post" action="${pageContext.request.contextPath}/admin/pedidos?acao=addItem">
            <input type="hidden" name="pedidoId" value="${pedido.id}">
            <div class="form-group">
                <label class="form-label">Produto</label>
                <select name="produtoId" class="form-control" required>
                    <option value="">Seleccione</option>
                    <c:forEach var="p" items="${produtos}">
                        <option value="${p.id}"><c:out value="${p.nome}"/> — <fmt:formatNumber value="${p.preco}" pattern="#,##0.00"/> MZN</option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group">
                <label class="form-label">Quantidade</label>
                <input type="number" name="quantidade" class="form-control" min="1" value="1" required>
            </div>
            <button type="submit" class="btn btn-gold w-100">+ Adicionar</button>
        </form>
    </div>
    </c:if>
</div>

</div></div>
</body>
</html>
