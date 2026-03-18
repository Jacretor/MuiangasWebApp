<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delivery — Muianga's Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
    /* ── FILTROS ── */
    .filtros-status { display:flex; gap:0.5rem; flex-wrap:wrap; margin-bottom:1.5rem; }
    .filtro-s { padding:0.4rem 1rem; border-radius:20px; border:1px solid #2A2218; background:transparent; color:#5A4E44; font-family:'Montserrat',sans-serif; font-size:0.68rem; font-weight:600; letter-spacing:1px; cursor:pointer; transition:all 0.2s; text-decoration:none; }
    .filtro-s:hover { border-color:#6B4C2A; color:#C0B4A8; }
    .filtro-s.active { background:#C8A951; border-color:#C8A951; color:#0E0C0A; }

    /* ── CARD ── */
    .delivery-card { background:#161210; border:1px solid #1E1814; border-radius:8px; padding:1.2rem 1.5rem; margin-bottom:1rem; }
    .delivery-card.pendente   { border-left:4px solid #C8A951; }
    .delivery-card.confirmado { border-left:4px solid #64A0DC; }
    .delivery-card.preparando { border-left:4px solid #E09040; }
    .delivery-card.a_caminho  { border-left:4px solid #78C878; }
    .delivery-card.entregue   { border-left:4px solid #50A050; opacity:0.7; }
    .delivery-card.cancelado  { border-left:4px solid #DC503C; opacity:0.6; }

    .dc-header { display:flex; align-items:flex-start; justify-content:space-between; flex-wrap:wrap; gap:0.8rem; margin-bottom:1rem; }
    .dc-id     { font-size:0.62rem; letter-spacing:2px; text-transform:uppercase; color:#4A4038; margin-bottom:0.3rem; }
    .dc-nome   { font-size:1rem; font-weight:700; color:#F0EAE0; }
    .dc-tel    { font-size:0.78rem; color:#C8A951; margin-top:0.2rem; }

    /* ── BARRA DE PROGRESSO ── */
    .progresso-wrap { margin:1rem 0; }
    .progresso-label { font-size:0.58rem; letter-spacing:2px; text-transform:uppercase; color:#3A3028; margin-bottom:0.6rem; }
    .progresso-steps { display:flex; align-items:center; gap:0; }
    .step {
        display:flex; flex-direction:column; align-items:center; gap:0.3rem;
        flex:1; position:relative; cursor:default;
    }
    .step-circle {
        width:32px; height:32px; border-radius:50%;
        border:2px solid #2A2218; background:#120F0C;
        display:flex; align-items:center; justify-content:center;
        font-size:0.9rem; transition:all 0.3s; z-index:1;
    }
    .step-label { font-size:0.55rem; letter-spacing:1px; text-transform:uppercase; color:#3A3028; text-align:center; }
    .step-line { position:absolute; top:16px; left:50%; right:-50%; height:2px; background:#1E1814; z-index:0; }
    .step:last-child .step-line { display:none; }

    /* Estados da barra */
    .step.done .step-circle  { background:#C8A951; border-color:#C8A951; }
    .step.done .step-label   { color:#C8A951; }
    .step.done .step-line    { background:#C8A951; }
    .step.atual .step-circle { background:rgba(200,169,81,0.2); border-color:#C8A951; animation:pulseBorder 1.5s infinite; }
    .step.atual .step-label  { color:#F0EAE0; font-weight:700; }

    @keyframes pulseBorder {
        0%,100% { box-shadow:0 0 0 0 rgba(200,169,81,0.4); }
        50%      { box-shadow:0 0 0 6px rgba(200,169,81,0); }
    }

    /* ── INFO GRID ── */
    .dc-info-grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(200px,1fr)); gap:0.8rem; margin-bottom:1rem; }
    .dc-info-item { background:#120F0C; border-radius:6px; padding:0.7rem 1rem; }
    .dc-info-label { font-size:0.58rem; letter-spacing:2px; text-transform:uppercase; color:#3A3028; margin-bottom:0.3rem; }
    .dc-info-val   { font-size:0.82rem; color:#C0B4A8; font-weight:500; }

    /* ── ITENS ── */
    .dc-itens { background:#120F0C; border-radius:6px; padding:0.8rem 1rem; margin-bottom:1rem; }
    .dc-item-row { display:flex; justify-content:space-between; padding:0.3rem 0; font-size:0.78rem; border-bottom:1px solid #1A1510; }
    .dc-item-row:last-child { border-bottom:none; }

    /* ── ACÇÕES ── */
    .dc-actions { display:flex; gap:0.6rem; flex-wrap:wrap; align-items:center; padding-top:1rem; border-top:1px solid #1A1510; }
    .dc-total-wrap { margin-left:auto; font-size:1rem; font-weight:900; color:#C8A951; }

    .btn-acao {
        padding:0.55rem 1.2rem; border-radius:6px; border:none;
        font-family:'Montserrat',sans-serif; font-size:0.72rem; font-weight:700;
        letter-spacing:0.5px; cursor:pointer; transition:all 0.2s; text-transform:uppercase;
    }
    .btn-confirmar  { background:rgba(100,160,220,0.15); color:#64A0DC; border:1px solid #64A0DC; }
    .btn-confirmar:hover  { background:#64A0DC; color:#0E0C0A; }
    .btn-preparar   { background:rgba(224,144,64,0.15); color:#E09040; border:1px solid #E09040; }
    .btn-preparar:hover   { background:#E09040; color:#0E0C0A; }
    .btn-caminho    { background:rgba(120,200,120,0.15); color:#78C878; border:1px solid #78C878; }
    .btn-caminho:hover    { background:#78C878; color:#0E0C0A; }
    .btn-entregue   { background:rgba(80,160,80,0.15); color:#50A050; border:1px solid #50A050; }
    .btn-entregue:hover   { background:#50A050; color:#0E0C0A; }
    .btn-cancelar   { background:rgba(220,80,60,0.15); color:#DC503C; border:1px solid #DC503C; }
    .btn-cancelar:hover   { background:#DC503C; color:#fff; }

    .badge-status { display:inline-flex; align-items:center; gap:0.4rem; padding:0.3rem 0.8rem; border-radius:20px; font-size:0.65rem; font-weight:700; letter-spacing:1px; text-transform:uppercase; }
    .bs-pendente   { background:rgba(200,169,81,0.15);  color:#C8A951; }
    .bs-confirmado { background:rgba(100,160,220,0.15); color:#64A0DC; }
    .bs-preparando { background:rgba(224,144,64,0.15);  color:#E09040; }
    .bs-a_caminho  { background:rgba(120,200,120,0.15); color:#78C878; }
    .bs-entregue   { background:rgba(80,160,80,0.15);   color:#50A050; }
    .bs-cancelado  { background:rgba(220,80,60,0.15);   color:#DC503C; }

    .pendente-alerta { background:rgba(200,169,81,0.1); border:1px solid rgba(200,169,81,0.3); border-radius:20px; padding:0.3rem 0.8rem; font-size:0.65rem; font-weight:700; color:#C8A951; letter-spacing:1px; }
    .vazio { text-align:center; padding:4rem 2rem; color:#3A3028; }
    .gps-link { font-size:0.75rem; color:#64A0DC; text-decoration:none; }
    .gps-link:hover { text-decoration:underline; }

    /* ── PAGAMENTO ── */
    .pag-info { display:flex; align-items:center; gap:0.8rem; background:#120F0C; border-radius:6px; padding:0.7rem 1rem; margin-bottom:0.8rem; flex-wrap:wrap; }
    .pag-metodo { font-size:0.72rem; font-weight:700; color:#C0B4A8; }
    .pag-badge  { display:inline-flex; align-items:center; gap:0.3rem; padding:0.2rem 0.7rem; border-radius:20px; font-size:0.62rem; font-weight:700; letter-spacing:1px; text-transform:uppercase; }
    .pb-pendente             { background:rgba(200,169,81,0.15);  color:#C8A951; }
    .pb-comprovativo_enviado { background:rgba(100,160,220,0.15); color:#64A0DC; }
    .pb-aprovado             { background:rgba(80,160,80,0.15);   color:#50A050; }
    .pb-rejeitado            { background:rgba(220,80,60,0.15);   color:#DC503C; }
    .btn-aprovar  { background:rgba(80,160,80,0.15);  color:#50A050; border:1px solid #50A050; }
    .btn-aprovar:hover  { background:#50A050; color:#fff; }
    .btn-rejeitar { background:rgba(220,80,60,0.15);  color:#DC503C; border:1px solid #DC503C; }
    .btn-rejeitar:hover { background:#DC503C; color:#fff; }
    .comp-img { max-width:100%; max-height:300px; border-radius:8px; border:1px solid #2A2218; margin-top:0.5rem; cursor:pointer; }
    .comp-wrap { margin-bottom:0.8rem; }
    .comp-label { font-size:0.6rem; letter-spacing:2px; text-transform:uppercase; color:#3A3028; margin-bottom:0.4rem; }

    @media(max-width:768px){
        .progresso-steps { gap:0; }
        .step-circle { width:26px; height:26px; font-size:0.75rem; }
        .step-label { font-size:0.48rem; }
        .dc-info-grid { grid-template-columns:1fr 1fr; }
    }
    </style>
</head>
<body>

<%@ include file="sidebar.jspf" %>

<div class="page-header">
    <div>
        <div class="page-title">🛵 Delivery</div>
        <div class="page-subtitle">Gestão de pedidos de entrega ao domicílio</div>
    </div>
    <c:if test="${pendentes > 0}">
        <span class="pendente-alerta">⚡ ${pendentes} pedido(s) pendente(s)</span>
    </c:if>
    <c:if test="${comProva > 0}">
        <span class="pendente-alerta" style="background:rgba(100,160,220,0.1);border-color:rgba(100,160,220,0.3);color:#64A0DC;">
            📎 ${comProva} comprovativo(s) por verificar
        </span>
    </c:if>
</div>

<c:if test="${not empty erro}">
    <div class="alert alert-danger">${erro}</div>
</c:if>

<!-- FILTROS -->
<div class="filtros-status">
    <a href="?status=todos"      class="filtro-s ${filtroAtual == 'todos'      || empty filtroAtual ? 'active' : ''}">Todos</a>
    <a href="?status=pendente"   class="filtro-s ${filtroAtual == 'pendente'   ? 'active' : ''}">⏳ Pendente</a>
    <a href="?status=confirmado" class="filtro-s ${filtroAtual == 'confirmado' ? 'active' : ''}">✅ Confirmado</a>
    <a href="?status=preparando" class="filtro-s ${filtroAtual == 'preparando' ? 'active' : ''}">👨‍🍳 A preparar</a>
    <a href="?status=a_caminho"  class="filtro-s ${filtroAtual == 'a_caminho'  ? 'active' : ''}">🛵 A caminho</a>
    <a href="?status=entregue"   class="filtro-s ${filtroAtual == 'entregue'   ? 'active' : ''}">🏠 Entregue</a>
    <a href="?status=cancelado"  class="filtro-s ${filtroAtual == 'cancelado'  ? 'active' : ''}">❌ Cancelado</a>
</div>

<!-- PEDIDOS -->
<c:choose>
<c:when test="${empty pedidos}">
    <div class="vazio">
        <div style="font-size:3rem;margin-bottom:1rem;">🛵</div>
        <p>Nenhum pedido encontrado.</p>
    </div>
</c:when>
<c:otherwise>
<c:forEach var="p" items="${pedidos}">

<%-- Calcular índice do passo actual --%>
<c:set var="passoAtual" value="0"/>
<c:if test="${p.status == 'confirmado'}"><c:set var="passoAtual" value="1"/></c:if>
<c:if test="${p.status == 'preparando'}"><c:set var="passoAtual" value="2"/></c:if>
<c:if test="${p.status == 'a_caminho'}" ><c:set var="passoAtual" value="3"/></c:if>
<c:if test="${p.status == 'entregue'}"  ><c:set var="passoAtual" value="4"/></c:if>
<c:if test="${p.status == 'cancelado'}" ><c:set var="passoAtual" value="-1"/></c:if>

<div class="delivery-card ${p.status}">

    <!-- CABEÇALHO -->
    <div class="dc-header">
        <div>
            <div class="dc-id">Pedido #${p.id} · <fmt:formatDate value="${p.dataHora}" pattern="dd/MM/yyyy HH:mm"/></div>
            <div class="dc-nome"><c:out value="${p.clienteNome}"/></div>
            <div class="dc-tel">📞 <c:out value="${p.clienteTelefone}"/></div>
        </div>
        <span class="badge-status bs-${p.status}">
            <c:choose>
                <c:when test="${p.status == 'pendente'}">Pendente</c:when>
                <c:when test="${p.status == 'confirmado'}"> Confirmado</c:when>
                <c:when test="${p.status == 'preparando'}">‍ A preparar</c:when>
                <c:when test="${p.status == 'a_caminho'}"> A caminho</c:when>
                <c:when test="${p.status == 'entregue'}">Entregue</c:when>
                <c:when test="${p.status == 'cancelado'}">❌ Cancelado</c:when>
            </c:choose>
        </span>
    </div>

    <!-- BARRA DE PROGRESSO -->
    <c:if test="${p.status != 'cancelado'}">
    <div class="progresso-wrap">
        <div class="progresso-label">Progresso do pedido</div>
        <div class="progresso-steps">

            <div class="step ${passoAtual >= 0 ? (passoAtual > 0 ? 'done' : 'atual') : ''}">
                <div class="step-line"></div>
                <div class="step-circle"></div>
                <div class="step-label">Pendente</div>
            </div>

            <div class="step ${passoAtual >= 1 ? (passoAtual > 1 ? 'done' : 'atual') : ''}">
                <div class="step-line"></div>
                <div class="step-circle"></div>
                <div class="step-label">Confirmado</div>
            </div>

            <div class="step ${passoAtual >= 2 ? (passoAtual > 2 ? 'done' : 'atual') : ''}">
                <div class="step-line"></div>
                <div class="step-circle">👨‍</div>
                <div class="step-label">A preparar</div>
            </div>

            <div class="step ${passoAtual >= 3 ? (passoAtual > 3 ? 'done' : 'atual') : ''}">
                <div class="step-line"></div>
                <div class="step-circle"></div>
                <div class="step-label">A caminho</div>
            </div>

            <div class="step ${passoAtual >= 4 ? 'done' : ''}">
                <div class="step-circle"></div>
                <div class="step-label">Entregue</div>
            </div>

        </div>
    </div>
    </c:if>

    <!-- INFO -->
    <div class="dc-info-grid">
        <div class="dc-info-item">
            <div class="dc-info-label">Zona</div>
            <div class="dc-info-val">📍 <c:out value="${p.zonaNome}"/></div>
        </div>
        <div class="dc-info-item">
            <div class="dc-info-label">Morada</div>
            <div class="dc-info-val">
                <c:choose>
                    <c:when test="${not empty p.morada}"><c:out value="${p.morada}"/></c:when>
                    <c:otherwise><span style="color:#3A3028">Não indicada</span></c:otherwise>
                </c:choose>
            </div>
        </div>
        <c:if test="${not empty p.latitude}">
        <div class="dc-info-item">
            <div class="dc-info-label">GPS</div>
            <div class="dc-info-val">
                <a class="gps-link" target="_blank" href="https://www.google.com/maps?q=${p.latitude},${p.longitude}">
                    🗺️ Abrir no Maps
                </a>
            </div>
        </div>
        </c:if>
        <c:if test="${not empty p.observacoes}">
        <div class="dc-info-item">
            <div class="dc-info-label">Observações</div>
            <div class="dc-info-val"><c:out value="${p.observacoes}"/></div>
        </div>
        </c:if>
        <div class="dc-info-item">
            <div class="dc-info-label">Pagamento</div>
            <div class="dc-info-val">
                <c:choose>
                    <c:when test="${p.metodoPagamento == 'mpesa'}"> M-Pesa</c:when>
                    <c:when test="${p.metodoPagamento == 'emola'}"> e-Mola</c:when>
                    <c:otherwise> Na Entrega</c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- ITENS -->
    <div class="dc-itens">
        <div class="dc-info-label" style="margin-bottom:0.5rem">Itens do pedido</div>
        <div id="itens-${p.id}"></div>
        <script>
        (function(){
            try {
                var raw = '<c:out value="${p.itens}"/>';
                var itens = JSON.parse(raw);
                var html = '';
                itens.forEach(function(item){
                    var sub = (item.preco * item.qty).toLocaleString('pt-MZ',{minimumFractionDigits:2});
                    html += '<div class="dc-item-row">' +
                            '<span style="color:#C0B4A8">' + item.qty + 'x ' + item.nome + '</span>' +
                            '<span style="color:#C8A951;font-weight:700">' + sub + ' MZN</span>' +
                            '</div>';
                });
                document.getElementById('itens-${p.id}').innerHTML = html;
            } catch(e) {
                document.getElementById('itens-${p.id}').innerHTML = '<span style="color:#5A4E44;font-size:0.75rem">Itens não disponíveis</span>';
            }
        })();
        </script>
    </div>

    <!-- PAGAMENTO -->
    <div class="pag-info">
        <span class="pag-metodo">
            <c:choose>
                <c:when test="${p.metodoPagamento == 'mpesa'}"> M-Pesa</c:when>
                <c:when test="${p.metodoPagamento == 'emola'}"> eMola</c:when>
                <c:otherwise> Dinheiro</c:otherwise>
            </c:choose>
        </span>
        <span class="pag-badge pb-${p.pagamentoStatus}">
            <c:choose>
                <c:when test="${p.pagamentoStatus == 'pendente'}">⏳ Pagamento pendente</c:when>
                <c:when test="${p.pagamentoStatus == 'comprovativo_enviado'}">📎 Comprovativo enviado</c:when>
                <c:when test="${p.pagamentoStatus == 'aprovado'}">✅ Pagamento aprovado</c:when>
                <c:when test="${p.pagamentoStatus == 'rejeitado'}">❌ Pagamento rejeitado</c:when>
            </c:choose>
        </span>
    </div>

    <!-- COMPROVATIVO -->
    <c:if test="${not empty p.comprovativoPath}">
    <div class="comp-wrap">
        <div class="comp-label"> Comprovativo de pagamento</div>
        <img class="comp-img"
             src="${pageContext.request.contextPath}/comprovativos/${p.comprovativoPath}"
             alt="Comprovativo"
             onclick="window.open(this.src,'_blank')">
    </div>
    </c:if>

    <!-- ACÇÕES -->
    <div class="dc-actions">

        <c:if test="${p.status == 'pendente'}">
            <%-- Botões aprovar/rejeitar pagamento se comprovativo enviado --%>
            <c:if test="${p.pagamentoStatus == 'comprovativo_enviado'}">
                <form method="post" action="${pageContext.request.contextPath}/admin/delivery" style="margin:0">
                    <input type="hidden" name="id"   value="${p.id}">
                    <input type="hidden" name="acao" value="aprovarPagamento">
                    <input type="hidden" name="filtroAtual" value="${filtroAtual}">
                    <button class="btn-acao btn-aprovar">✅ Aprovar pagamento</button>
                </form>
                <form method="post" action="${pageContext.request.contextPath}/admin/delivery" style="margin:0">
                    <input type="hidden" name="id"   value="${p.id}">
                    <input type="hidden" name="acao" value="rejeitarPagamento">
                    <input type="hidden" name="filtroAtual" value="${filtroAtual}">
                    <button class="btn-acao btn-rejeitar">❌ Rejeitar</button>
                </form>
            </c:if>
            <%-- Dinheiro ou pagamento já aprovado: mostrar botão confirmar --%>
            <c:if test="${p.pagamentoStatus == 'aprovado'}">
                <form method="post" action="${pageContext.request.contextPath}/admin/delivery" style="margin:0">
                    <input type="hidden" name="id"     value="${p.id}">
                    <input type="hidden" name="status" value="confirmado">
                    <button class="btn-acao btn-confirmar">✅ Confirmar pedido</button>
                </form>
            </c:if>
            <form method="post" action="${pageContext.request.contextPath}/admin/delivery" style="margin:0">
                <input type="hidden" name="id"     value="${p.id}">
                <input type="hidden" name="status" value="cancelado">
                <button class="btn-acao btn-cancelar">❌ Cancelar</button>
            </form>
        </c:if>

        <c:if test="${p.status == 'confirmado'}">
            <form method="post" action="${pageContext.request.contextPath}/admin/delivery" style="margin:0">
                <input type="hidden" name="id" value="${p.id}">
                <input type="hidden" name="status" value="preparando">
                <button class="btn-acao btn-preparar"> Iniciar preparação</button>
            </form>
        </c:if>

        <c:if test="${p.status == 'preparando'}">
            <form method="post" action="${pageContext.request.contextPath}/admin/delivery" style="margin:0">
                <input type="hidden" name="id" value="${p.id}">
                <input type="hidden" name="status" value="a_caminho">
                <button class="btn-acao btn-caminho">Saiu para entrega</button>
            </form>
        </c:if>

        <c:if test="${p.status == 'a_caminho'}">
            <form method="post" action="${pageContext.request.contextPath}/admin/delivery" style="margin:0">
                <input type="hidden" name="id" value="${p.id}">
                <input type="hidden" name="status" value="entregue">
                <button class="btn-acao btn-entregue">🏠 Marcar como entregue</button>
            </form>
        </c:if>

        <div class="dc-total-wrap">
            Taxa: <fmt:formatNumber value="${p.taxaEntrega}" pattern="#,##0.00"/> MZN &nbsp;|&nbsp;
            Total: <fmt:formatNumber value="${p.total}" pattern="#,##0.00"/> MZN
        </div>
    </div>

</div>
</c:forEach>
</c:otherwise>
</c:choose>

</div><%-- fecha main-content --%>

<!-- AUTO-REFRESH a cada 60 segundos para ver novos pedidos -->
<script>
setTimeout(function(){ location.reload(); }, 60000);
</script>

</body>
</html>

<%-- NOTA: Adicionar ao AdminDeliveryServlet.java o tratamento de aprovar/rejeitar pagamento --%>
