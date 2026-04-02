<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delivery — Muianga's</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body { padding-top: 70px; background: #0E0C0A; }
        .delivery-hero { background:linear-gradient(135deg,#120F0C,#1A1410); padding:3rem 2rem 2rem; text-align:center; border-bottom:1px solid #1E1814; }
        .delivery-hero h1 { font-size:clamp(2rem,5vw,3rem); font-weight:900; letter-spacing:5px; color:#C8A951; }
        .delivery-hero p  { font-size:0.72rem; letter-spacing:3px; text-transform:uppercase; color:#4A4038; margin-top:0.5rem; }
        .encerrado-banner, .sucesso-banner { max-width:600px; margin:3rem auto; text-align:center; background:#161210; border:1px solid #2A2218; border-radius:8px; padding:3rem 2rem; }
        .sucesso-banner { border-color:rgba(90,138,90,0.3); }
        .horario-badge { display:inline-block; margin-top:1.5rem; background:rgba(200,169,81,0.1); border:1px solid rgba(200,169,81,0.3); border-radius:20px; padding:0.5rem 1.5rem; color:#C8A951; font-size:0.8rem; font-weight:700; letter-spacing:2px; }
        .delivery-wrap { max-width:1100px; margin:2rem auto; padding:0 2rem; display:grid; grid-template-columns:1fr 370px; gap:2rem; align-items:start; }
        .filtros-sticky { position:sticky; top:68px; z-index:20; background:rgba(14,12,10,0.97); backdrop-filter:blur(12px); border-bottom:1px solid #1E1814; padding:0.8rem 0; margin-bottom:1.2rem; display:flex; gap:0.5rem; flex-wrap:wrap; }
        .cat-btn { padding:0.4rem 1rem; border-radius:20px; border:1px solid #2A2218; background:transparent; color:#5A4E44; font-family:'Montserrat',sans-serif; font-size:0.68rem; font-weight:600; letter-spacing:1px; cursor:pointer; transition:all 0.2s; }
        .cat-btn:hover { border-color:#6B4C2A; color:#C0B4A8; }
        .cat-btn.active { background:#C8A951; border-color:#C8A951; color:#0E0C0A; }
        .sec-titulo { font-size:0.65rem; letter-spacing:4px; text-transform:uppercase; color:#C8A951; margin-bottom:0.8rem; display:flex; align-items:center; gap:0.8rem; }
        .sec-titulo::before { content:''; width:30px; height:1px; background:#C8A951; }
        .prod-contador { font-size:0.68rem; color:#3A3028; letter-spacing:1px; margin-bottom:1rem; }
        .produtos-grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(180px,1fr)); gap:1rem; }
        .prod-card { background:#161210; border:1px solid #1E1814; border-radius:8px; overflow:hidden; transition:all 0.2s; }
        .prod-card:hover { border-color:#6B4C2A; transform:translateY(-2px); }
        .prod-card.oculto { display:none; }
        .prod-img   { width:100%; height:120px; object-fit:cover; display:block; }
        .prod-emoji { width:100%; height:120px; background:#1A1510; display:flex; align-items:center; justify-content:center; font-size:2.5rem; }
        .prod-body  { padding:0.8rem; }
        .prod-cat   { font-size:0.58rem; letter-spacing:2px; text-transform:uppercase; color:#C8A951; }
        .prod-nome  { font-size:0.85rem; font-weight:700; color:#F0EAE0; margin:0.2rem 0; }
        .prod-preco { font-size:0.9rem; font-weight:900; color:#C8A951; margin-bottom:0.5rem; }
        .btn-add { width:100%; background:#C8A951; color:#0E0C0A; border:none; border-radius:4px; padding:0.5rem; font-family:'Montserrat',sans-serif; font-size:0.72rem; font-weight:800; cursor:pointer; transition:all 0.2s; letter-spacing:1px; }
        .btn-add:hover { background:#E4C97A; }
        .btn-add.adicionado { background:#80C080; color:#fff; }
        .carrinho-box { background:#161210; border:1px solid #1E1814; border-radius:8px; position:sticky; top:80px; }
        .carrinho-header { padding:1.2rem 1.5rem; border-bottom:1px solid #1E1814; display:flex; align-items:center; justify-content:space-between; }
        .carrinho-titulo { font-size:0.65rem; letter-spacing:3px; text-transform:uppercase; color:#C8A951; font-weight:700; }
        .carrinho-badge  { background:rgba(200,169,81,0.15); color:#C8A951; border-radius:20px; padding:0.15rem 0.6rem; font-size:0.65rem; font-weight:700; }
        .carrinho-itens  { padding:1rem 1.5rem; min-height:80px; max-height:200px; overflow-y:auto; }
        .carrinho-vazio  { text-align:center; color:#3A3028; font-size:0.8rem; padding:1.5rem 0; }
        .cart-row { display:flex; align-items:center; gap:0.5rem; padding:0.45rem 0; border-bottom:1px solid #1A1510; font-size:0.78rem; }
        .cart-row:last-child { border-bottom:none; }
        .cart-nome  { flex:1; color:#C0B4A8; font-weight:600; font-size:0.75rem; }
        .cart-preco { color:#C8A951; font-weight:700; white-space:nowrap; font-size:0.75rem; }
        .qty-ctrl { display:flex; align-items:center; gap:0.3rem; }
        .qty-btn  { background:#1E1A16; border:1px solid #2A2218; color:#C8A951; width:22px; height:22px; border-radius:4px; cursor:pointer; font-size:0.85rem; font-weight:900; display:flex; align-items:center; justify-content:center; }
        .qty-btn:hover { background:#C8A951; color:#0E0C0A; }
        .qty-num  { font-size:0.8rem; color:#F0EAE0; font-weight:700; min-width:16px; text-align:center; }
        .carrinho-totais { padding:0.8rem 1.5rem; border-top:1px solid #1E1814; }
        .total-row { display:flex; justify-content:space-between; font-size:0.78rem; padding:0.2rem 0; }
        .total-row span:first-child { color:#5A4E44; }
        .total-row span:last-child  { color:#C0B4A8; font-weight:600; }
        .total-final { display:flex; justify-content:space-between; padding-top:0.6rem; margin-top:0.4rem; border-top:1px solid #1E1814; }
        .total-final span:first-child { font-size:0.72rem; font-weight:700; letter-spacing:1px; text-transform:uppercase; color:#C8A951; }
        .total-final span:last-child  { font-size:1.1rem; font-weight:900; color:#C8A951; }
        .form-section { padding:1.2rem 1.5rem; border-top:1px solid #1E1814; }
        .form-section h3 { font-size:0.6rem; letter-spacing:3px; text-transform:uppercase; color:#4A4038; margin-bottom:1rem; }
        .gps-btn { width:100%; background:rgba(200,169,81,0.08); border:1px solid rgba(200,169,81,0.3); color:#C8A951; padding:0.65rem; border-radius:6px; cursor:pointer; font-family:'Montserrat',sans-serif; font-size:0.72rem; font-weight:600; letter-spacing:1px; transition:all 0.2s; margin-bottom:0.4rem; }
        .gps-status { font-size:0.68rem; color:#5A4E44; text-align:center; margin-bottom:0.8rem; min-height:1rem; }
        .gps-status.ok { color:#80C080; }

        /* ── PAGAMENTO ── */
        .pagamento-opcoes { display:grid; grid-template-columns:1fr 1fr 1fr; gap:0.5rem; margin-bottom:1rem; }
        .pag-btn {
            padding:0.7rem 0.4rem; border-radius:8px; border:2px solid #2A2218;
            background:#120F0C; color:#5A4E44; font-family:'Montserrat',sans-serif;
            font-size:0.65rem; font-weight:700; letter-spacing:0.5px; cursor:pointer;
            transition:all 0.2s; text-align:center; display:flex; flex-direction:column;
            align-items:center; gap:0.3rem;
        }
        .pag-btn .pag-icone { font-size:1.3rem; }
        .pag-btn:hover { border-color:#6B4C2A; color:#C0B4A8; }
		.pag-btn.sel-mpesa { border-color: #FF0000;  background: rgba(255, 0, 0, 0.1); color: #FF0000; }
		.pag-btn.sel-emola { border-color: #FF6600; background: rgba(255, 102, 0, 0.1); color: #FF6600; }
        .pag-btn.sel-dinheiro { border-color:#78C878; background:rgba(120,200,120,0.1); color:#78C878; }

        .instrucoes-pag {
            background:#120F0C; border-radius:8px; padding:1rem;
            margin-bottom:1rem; display:none; border:1px solid #2A2218;
        }
        .instrucoes-pag.visivel { display:block; }
        .instr-titulo { font-size:0.6rem; letter-spacing:2px; text-transform:uppercase; color:#E07070; margin-bottom:0.6rem; }
        .instr-numero { font-size:1.1rem; font-weight:900; color: #E07070; letter-spacing:2px; margin:0.3rem 0; }
        .instr-nome   { font-size:0.78rem; color:#C0B4A8; margin-bottom:0.5rem; }
        .instr-passo  { font-size:0.72rem; color:#5A4E44; line-height:1.8; }
        .instr-passo strong { color:#C0B4A8; }

        .upload-area {
            border:2px dashed #2A2218; border-radius:8px; padding:1rem;
            text-align:center; cursor:pointer; transition:all 0.2s; margin-bottom:0.8rem;
            display:none;
        }
        .upload-area.visivel { display:block; }
        .upload-area:hover   { border-color:#C8A951; }
        .upload-area.tem-ficheiro { border-color:#78C878; background:rgba(120,200,120,0.05); }
        .upload-icon  { font-size:1.8rem; margin-bottom:0.4rem; }
        .upload-texto { font-size:0.72rem; color:#5A4E44; }
        .upload-nome  { font-size:0.72rem; color:#78C878; font-weight:600; margin-top:0.3rem; display:none; }

        .btn-encomendar { width:100%; background:#C8A951; color:#0E0C0A; border:none; border-radius:6px; padding:0.9rem; font-family:'Montserrat',sans-serif; font-size:0.78rem; font-weight:800; letter-spacing:2px; text-transform:uppercase; cursor:pointer; transition:all 0.2s; margin-top:0.8rem; }
        .btn-encomendar:hover    { background:#E4C97A; }
        .btn-encomendar:disabled { background:#2A2218; color:#4A4038; cursor:not-allowed; }
        .erro-box { max-width:700px; margin:1.5rem auto; background:#2A1010; border:1px solid #E07060; border-radius:8px; padding:1.2rem 1.5rem; color:#E07060; font-size:0.85rem; }

        /* SUCESSO COM INSTRUCOES */
        .sucesso-pag { background:#120F0C; border:1px solid rgba(200,169,81,0.3); border-radius:8px; padding:1.2rem; margin-top:1.2rem; text-align:left; }
        .sucesso-pag-titulo { font-size:0.6rem; letter-spacing:2px; text-transform:uppercase; color:#C8A951; margin-bottom:0.5rem; }
        .sucesso-numero { font-size:1.3rem; font-weight:900; color:#C8A951; letter-spacing:3px; }

        @media(max-width:768px){
            .delivery-wrap { grid-template-columns:1fr; padding:0 1rem; }
            .carrinho-box  { position:static; }
            .pagamento-opcoes { grid-template-columns:1fr 1fr 1fr; }
        }
    </style>
</head>
<body>

<nav class="navbar">
    <div class="navbar-brand">MUIANGA'S <span>Bar &amp; Restaurante</span></div>
    <ul class="navbar-nav">
        <li><a href="${pageContext.request.contextPath}/views/public/index.jsp">Início</a></li>
        <li><a href="${pageContext.request.contextPath}/menu">Menu</a></li>
        <li><a href="${pageContext.request.contextPath}/reserva">Reserva</a></li>
        <li><a href="${pageContext.request.contextPath}/delivery" class="active">Delivery</a></li>
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

<div class="delivery-hero">
    <h1> DELIVERY</h1>
    <p>Entrega ao domicílio · Chimoio · Das 8h às 20h</p>
</div>

<c:if test="${not empty erroServlet}">
    <div class="erro-box" style="text-align:center;">⚠️ Erro: <strong>${erroServlet}</strong></div>
</c:if>

<%-- ══ SUCESSO ══ --%>
<c:if test="${not empty param.sucesso}">
    <div class="sucesso-banner">
        <div style="font-size:3rem;margin-bottom:0.8rem;">✅</div>
        <h2 style="color:#80C080;font-size:1.4rem;font-weight:900;margin-bottom:0.5rem;">Pedido Recebido!</h2>
        <p style="color:#5A4E44;font-size:0.88rem;line-height:1.8;">
            Pedido <strong style="color:#C8A951;">#${param.sucesso}</strong> registado!<br>
            Entraremos em contacto pelo telefone para confirmar.
        </p>

        <%-- Instrucoes pos-pagamento M-Pesa --%>
        <c:if test="${param.metodo == 'mpesa'}">
            <div class="sucesso-pag">
                <div class="sucesso-pag-titulo">📱 Pagamento via M-Pesa</div>
                <p style="font-size:0.78rem;color:#5A4E44;margin-bottom:0.5rem;">Se ainda não pagou, envie o valor para:</p>
                <div class="sucesso-numero">${mpesaNumero}</div>
                <div style="font-size:0.78rem;color:#C0B4A8;margin:0.3rem 0;">${pagamentoNome}</div>
                <p style="font-size:0.72rem;color:#4A4038;margin-top:0.5rem;">Aguarde a confirmação da nossa equipa após verificar o comprovativo.</p>
            </div>
        </c:if>
        <c:if test="${param.metodo == 'emola'}">
            <div class="sucesso-pag" style="border-color:rgba(224,80,80,0.3);">
                <div class="sucesso-pag-titulo" style="color:#E07070;">📱 Pagamento via eMola</div>
                <p style="font-size:0.78rem;color:#5A4E44;margin-bottom:0.5rem;">Se ainda não pagou, envie o valor para:</p>
                <div class="sucesso-numero" style="color:#E07070;">${emolaNumero}</div>
                <div style="font-size:0.78rem;color:#C0B4A8;margin:0.3rem 0;">${pagamentoNome}</div>
                <p style="font-size:0.72rem;color:#4A4038;margin-top:0.5rem;">Aguarde a confirmação da nossa equipa após verificar o comprovativo.</p>
            </div>
        </c:if>
        <c:if test="${param.metodo == 'dinheiro'}">
            <div class="sucesso-pag" style="border-color:rgba(120,200,120,0.3);">
                <div class="sucesso-pag-titulo" style="color:#78C878;">💵 Pagamento em Dinheiro</div>
                <p style="font-size:0.78rem;color:#5A4E44;">O pagamento será efectuado na entrega. Tenha o dinheiro exacto disponível.</p>
            </div>
        </c:if>

        <a href="${pageContext.request.contextPath}/delivery" style="display:inline-block;margin-top:1.5rem;" class="btn btn-gold">Novo Pedido</a>
    </div>
</c:if>

<%-- ══ ENCERRADO ══ --%>
<c:if test="${aberto == false && empty param.sucesso}">
    <div class="encerrado-banner">
        <div style="font-size:3.5rem;margin-bottom:1rem;">🌙</div>
        <h2 style="font-size:1.4rem;font-weight:900;color:#F0EAE0;margin-bottom:0.5rem;">Delivery Encerrado</h2>
        <p style="color:#5A4E44;font-size:0.88rem;">Serviço de entrega temporariamente encerrado.</p>
        <div class="horario-badge">Disponível das ${horaAbertura}h às ${horaEncerramento}h</div>
        <br><br>
        <a href="${pageContext.request.contextPath}/views/public/index.jsp" class="btn btn-outline">Voltar ao Início</a>
    </div>
</c:if>

<%-- ══ FORMULÁRIO ══ --%>
<c:if test="${aberto == true && empty param.sucesso}">

<%-- AUTH GUARD — visitante não logado --%>
<c:if test="${empty sessionScope.cliente}">
<div style="max-width:500px;margin:4rem auto;text-align:center;background:#161210;border:1px solid rgba(200,169,81,0.15);border-radius:14px;padding:3rem 2.5rem;">
    <div style="width:60px;height:60px;border-radius:50%;background:rgba(200,169,81,0.08);border:1px solid rgba(200,169,81,0.2);display:flex;align-items:center;justify-content:center;margin:0 auto 1.5rem;">
        <svg viewBox="0 0 24 24" width="28" height="28" fill="none" stroke="#C8A951" stroke-width="1.5" stroke-linecap="round"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0110 0v4"/></svg>
    </div>
    <h2 style="font-family:'Playfair Display',serif;font-size:1.5rem;color:#F0EAE0;margin-bottom:0.8rem;">Conta necessária</h2>
    <p style="font-size:0.82rem;color:#4A4038;line-height:1.8;margin-bottom:2rem;">Para fazer um pedido de delivery precisas de uma conta. É gratuito e permite acompanhar os teus pedidos.</p>
    <a href="${pageContext.request.contextPath}/cliente/registo?redirect=/delivery"
       style="display:block;width:100%;padding:0.9rem;border-radius:50px;border:1.5px solid #C8A951;background:transparent;color:#C8A951;font-family:'Montserrat',sans-serif;font-size:0.72rem;font-weight:700;letter-spacing:2px;text-transform:uppercase;text-decoration:none;text-align:center;transition:all 0.25s;margin-bottom:0.8rem;">
        Criar conta gratuita
    </a>
    <div style="display:flex;align-items:center;gap:1rem;margin:0.6rem 0;">
        <div style="flex:1;height:1px;background:#1E1814;"></div>
        <span style="font-size:0.6rem;color:#2A2218;letter-spacing:2px;text-transform:uppercase;">ou</span>
        <div style="flex:1;height:1px;background:#1E1814;"></div>
    </div>
    <a href="${pageContext.request.contextPath}/cliente/login?redirect=/delivery"
       style="display:block;width:100%;padding:0.85rem;border-radius:50px;border:1.5px solid #1E1814;background:transparent;color:#5A4E44;font-family:'Montserrat',sans-serif;font-size:0.7rem;font-weight:600;letter-spacing:1.5px;text-transform:uppercase;text-decoration:none;text-align:center;transition:all 0.2s;">
        Já tenho conta — Entrar
    </a>
</div>
</c:if>

<%-- Conteúdo só para clientes logados --%>
<c:if test="${not empty sessionScope.cliente}">

<c:if test="${not empty erro}">
    <div class="erro-box">⚠️ <c:out value="${erro}"/></div>
</c:if>

<div class="delivery-wrap">

    <%-- PRODUTOS --%>
    <div>
        <div class="sec-titulo">Escolhe os teus produtos</div>
        <div class="filtros-sticky">
            <button class="cat-btn active" data-catid="0" onclick="filtrar(this)">Todos</button>
            <c:forEach var="cat" items="${categorias}">
                <button class="cat-btn" data-catid="${cat.id}" onclick="filtrar(this)">
                    <c:out value="${cat.nome}"/>
                </button>
            </c:forEach>
        </div>
        <div class="prod-contador" id="contador"></div>
        <div class="produtos-grid" id="gridProd">
            <c:forEach var="p" items="${produtos}">
                <div class="prod-card" data-catid="${p.categoriaId}">
                    <c:choose>
                        <c:when test="${not empty p.imagem}">
                            <img class="prod-img" src="${pageContext.request.contextPath}/imagens_produtos/${p.imagem}" alt="produto">
                        </c:when>
                        <c:otherwise><div class="prod-emoji">🍽️</div></c:otherwise>
                    </c:choose>
                    <div class="prod-body">
                        <div class="prod-cat"><c:out value="${p.categoriaNome}"/></div>
                        <div class="prod-nome"><c:out value="${p.nome}"/></div>
                        <div class="prod-preco"><fmt:formatNumber value="${p.preco}" pattern="#,##0.00"/> MZN</div>
                        <button class="btn-add" onclick="adicionarProd(${p.id}, '<c:out value="${p.nome}"/>', ${p.preco}, this)">
                            + Adicionar
                        </button>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

    <%-- CARRINHO + FORM --%>
    <div class="carrinho-box">
        <div class="carrinho-header">
            <span class="carrinho-titulo"> O seu pedido</span>
            <span class="carrinho-badge" id="cartBadge">0 itens</span>
        </div>
        <div class="carrinho-itens" id="cartItens">
            <div class="carrinho-vazio" id="cartVazio">Adiciona produtos ao carrinho</div>
        </div>
        <div class="carrinho-totais">
            <div class="total-row"><span>Subtotal</span><span id="valSubtotal">0,00 MZN</span></div>
            <div class="total-row"><span>Taxa de entrega</span><span id="valTaxa">— MZN</span></div>
            <div class="total-final"><span>Total</span><span id="valTotal">0,00 MZN</span></div>
        </div>

        <div class="form-section">
            <h3>Dados de entrega</h3>
            <div class="form-group">
                <label class="form-label">Nome *</label>
                <input type="text" id="fNome" class="form-control" placeholder="O seu nome">
            </div>
            <div class="form-group">
                <label class="form-label">Telefone *</label>
                <input type="tel" id="fTel" class="form-control" placeholder="+258 84 000 0000">
            </div>
            <div class="form-group">
                <label class="form-label">Zona de entrega *</label>
                <select id="fZona" class="form-control" onchange="mudarZona()">
                    <option value="">Seleccione a sua zona</option>
                    <c:forEach var="z" items="${zonas}">
                        <option value="${z.id}" data-taxa="${z.taxaEntrega}">
                            <c:out value="${z.nome}"/> — <fmt:formatNumber value="${z.taxaEntrega}" pattern="#,##0"/> MZN
                        </option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group">
                <label class="form-label">Referência / Morada</label>
                <input type="text" id="fMorada" class="form-control" placeholder="Ex: Perto do Mercado Central">
            </div>
            <button class="gps-btn" type="button" onclick="obterGPS()"> Usar localização GPS</button>
            <div class="gps-status" id="gpsStatus">Localização não obtida</div>
            <input type="hidden" id="fLat">
            <input type="hidden" id="fLng">
            <div class="form-group">
                <label class="form-label">Observações</label>
                <textarea id="fObs" class="form-control" rows="2" placeholder="Ex: Sem cebola..."></textarea>
            </div>
        </div>

        <%-- ── PAGAMENTO ── --%>
        <div class="form-section" style="border-top:1px solid #1E1814;padding-top:1rem;">
            <h3>Método de pagamento *</h3>
            <div class="pagamento-opcoes">
                <button class="pag-btn" id="btn-mpesa"    type="button" onclick="selecionarPag('mpesa')">
                    M-Pesa
                </button>
                <button class="pag-btn" id="btn-emola"    type="button" onclick="selecionarPag('emola')">
                  eMola
                </button>
                <button class="pag-btn" id="btn-dinheiro" type="button" onclick="selecionarPag('dinheiro')">
                    Dinheiro
                </button>
            </div>

            <%-- Instruções M-Pesa --%>
            <div class="instrucoes-pag" id="instr-mpesa">
                <div class="instr-titulo"> Instruções M-Pesa</div>
                <div class="instr-numero">${mpesaNumero}</div>
                <div class="instr-nome">${pagamentoNome}</div>
                <div class="instr-passo">
                    1. Abre o M-Pesa no teu telefone<br>
                    2. Selecciona <strong>Transferir</strong><br>
                    3. Insere o número acima<br>
                    4. Insere o valor total do pedido<br>
                    5. Faz uma captura de ecrã e anexa abaixo
                </div>
            </div>

            <%-- Instruções eMola --%>
            <div class="instrucoes-pag" id="instr-emola">
                <div class="instr-titulo" style="color:#C8A951;"> Instruções eMola</div>
                <div class="instr-numero" style="color:#C8A951;">${emolaNumero}</div>
                <div class="instr-nome">${pagamentoNome}</div>
                <div class="instr-passo">
                    1. Abre o eMola no teu telefone<br>
                    2. Selecciona <strong>Transferir</strong><br>
                    3. Insere o número acima<br>
                    4. Insere o valor total do pedido<br>
                    5. Faz uma captura de ecrã e anexa abaixo
                </div>
            </div>

            <%-- Upload comprovativo --%>
            <div class="upload-area" id="uploadArea" onclick="document.getElementById('fComp').click()">
                <div class="upload-icon">📷</div>
                <div class="upload-texto">Clica para anexar o comprovativo de pagamento</div>
                <div class="upload-nome" id="uploadNome"></div>
            </div>

            <%-- Dinheiro --%>
            <div class="instrucoes-pag" id="instr-dinheiro" style="border-color:rgba(120,200,120,0.2);">
                <div class="instr-titulo" style="color:#78C878;"> Pagamento em Dinheiro</div>
                <div class="instr-passo">
                    O pagamento será efectuado na entrega.<br>
                    Tenha o <strong>dinheiro exacto</strong> disponível.<br>
                    O pedido será confirmado após aprovação.
                </div>
            </div>

            <button class="btn-encomendar" id="btnEncomendar" type="button"
                    onclick="submeter()" disabled>
                Encomendar Agora
            </button>
        </div>
    </div>
</div>

<%-- FORM OCULTO (multipart para suportar upload) --%>
<form id="fForm" method="post" enctype="multipart/form-data"
      action="${pageContext.request.contextPath}/delivery" style="display:none;">
    <input type="hidden" name="nome"            id="hNome">
    <input type="hidden" name="telefone"        id="hTel">
    <input type="hidden" name="zonaId"          id="hZona">
    <input type="hidden" name="morada"          id="hMorada">
    <input type="hidden" name="latitude"        id="hLat">
    <input type="hidden" name="longitude"       id="hLng">
    <input type="hidden" name="itens"           id="hItens">
    <input type="hidden" name="total"           id="hTotal">
    <input type="hidden" name="observacoes"     id="hObs">
    <input type="hidden" name="metodoPagamento" id="hMetodo">
    <input type="file"   name="comprovativo"    id="fComp" accept="image/*">
</form>

</c:if><%-- fecha sessionScope.cliente --%>

</c:if><%-- fecha aberto --%>

<footer style="margin-top:4rem;">
    <strong>MUIANGA'S</strong> Bar &amp; Restaurante · Delivery das 9h às 17h · &copy; 2026
</footer>

<script>
var cart     = {};
var taxa     = 0;
var metodoPag = '';

// ── FILTRO ────────────────────────────────────────────
function filtrar(btn) {
    var catId = btn.getAttribute('data-catid');
    var botoes = document.querySelectorAll('.cat-btn');
    for (var i = 0; i < botoes.length; i++) botoes[i].classList.remove('active');
    btn.classList.add('active');
    var cards = document.querySelectorAll('.prod-card');
    var n = 0;
    for (var j = 0; j < cards.length; j++) {
        var show = catId === '0' || cards[j].getAttribute('data-catid') === catId;
        cards[j].classList.toggle('oculto', !show);
        if (show) n++;
    }
    var c = document.getElementById('contador');
    if (c) c.textContent = n + (n === 1 ? ' produto' : ' produtos');
}
(function(){
    var cards = document.querySelectorAll('.prod-card');
    var c = document.getElementById('contador');
    if (c) c.textContent = cards.length + ' produtos';
})();

// ── CARRINHO ──────────────────────────────────────────
function adicionarProd(id, nome, preco, btn) {
    id = String(id);
    if (cart[id]) { cart[id].qty += 1; }
    else           { cart[id] = {id:id, nome:nome, preco:preco, qty:1}; }
    renderCart();
    btn.textContent = '✓ Adicionado';
    btn.classList.add('adicionado');
    setTimeout(function(){ btn.textContent = '+ Adicionar'; btn.classList.remove('adicionado'); }, 800);
}

function mudarQty(id, delta) {
    if (!cart[id]) return;
    cart[id].qty += delta;
    if (cart[id].qty <= 0) delete cart[id];
    renderCart();
}

function renderCart() {
    var itens = Object.values(cart);
    var count = 0; var subtotal = 0;
    for (var i = 0; i < itens.length; i++) { count += itens[i].qty; subtotal += itens[i].preco * itens[i].qty; }
    var total = subtotal + taxa;
    document.getElementById('cartBadge').textContent   = count + (count === 1 ? ' item' : ' itens');
    document.getElementById('valSubtotal').textContent = fmtMzn(subtotal);
    document.getElementById('valTotal').textContent    = fmtMzn(total);
    verificarBotao();
    var container = document.getElementById('cartItens');
    var vazio     = document.getElementById('cartVazio');
    var linhas    = container.querySelectorAll('.cart-row');
    for (var k = 0; k < linhas.length; k++) linhas[k].remove();
    if (count === 0) { vazio.style.display = 'block'; return; }
    vazio.style.display = 'none';
    for (var m = 0; m < itens.length; m++) {
        var item = itens[m];
        var div  = document.createElement('div');
        div.className = 'cart-row';
        div.innerHTML = '<span class="cart-nome">' + item.nome + '</span>' +
            '<div class="qty-ctrl">' +
            '<button class="qty-btn" onclick="mudarQty(\'' + item.id + '\',-1)">−</button>' +
            '<span class="qty-num">' + item.qty + '</span>' +
            '<button class="qty-btn" onclick="mudarQty(\'' + item.id + '\',1)">+</button>' +
            '</div><span class="cart-preco">' + fmtMzn(item.preco * item.qty) + '</span>';
        container.appendChild(div);
    }
}

// ── ZONA ──────────────────────────────────────────────
function mudarZona() {
    var sel = document.getElementById('fZona');
    var opt = sel.options[sel.selectedIndex];
    taxa = opt && opt.getAttribute('data-taxa') ? parseFloat(opt.getAttribute('data-taxa')) : 0;
    document.getElementById('valTaxa').textContent = taxa > 0 ? fmtMzn(taxa) : '— MZN';
    renderCart();
}

// ── PAGAMENTO ─────────────────────────────────────────
function selecionarPag(metodo) {
    metodoPag = metodo;

    // reset botões
    var btns = ['mpesa','emola','dinheiro'];
    for (var i = 0; i < btns.length; i++) {
        var b = document.getElementById('btn-' + btns[i]);
        b.className = 'pag-btn';
    }
    document.getElementById('btn-' + metodo).className = 'pag-btn sel-' + metodo;

    // esconder todas as instruções
    document.getElementById('instr-mpesa').classList.remove('visivel');
    document.getElementById('instr-emola').classList.remove('visivel');
    document.getElementById('instr-dinheiro').classList.remove('visivel');
    document.getElementById('uploadArea').classList.remove('visivel');

    // mostrar instrução certa
    document.getElementById('instr-' + metodo).classList.add('visivel');

    // upload só para mpesa e emola
    if (metodo === 'mpesa' || metodo === 'emola') {
        document.getElementById('uploadArea').classList.add('visivel');
    }

    verificarBotao();
}

// upload comprovativo
document.addEventListener('DOMContentLoaded', function() {
    var fComp = document.getElementById('fComp');
    if (fComp) {
        fComp.addEventListener('change', function() {
            var area = document.getElementById('uploadArea');
            var nome = document.getElementById('uploadNome');
            if (this.files && this.files[0]) {
                area.classList.add('tem-ficheiro');
                nome.textContent = '✅ ' + this.files[0].name;
                nome.style.display = 'block';
            } else {
                area.classList.remove('tem-ficheiro');
                nome.style.display = 'none';
            }
            verificarBotao();
        });
    }
});

// ── BOTÃO ENCOMENDAR ──────────────────────────────────
function verificarBotao() {
    var count = Object.values(cart).reduce(function(s,i){ return s + i.qty; }, 0);
    var temComp = document.getElementById('fComp') && document.getElementById('fComp').files.length > 0;
    var podePagar = metodoPag === 'dinheiro' || (metodoPag && temComp);
    document.getElementById('btnEncomendar').disabled = (count === 0 || !metodoPag || !podePagar);
}

// ── GPS ───────────────────────────────────────────────
function obterGPS() {
    var status = document.getElementById('gpsStatus');
    if (!navigator.geolocation) { status.textContent = '⚠️ GPS não suportado'; return; }
    status.textContent = '📡 A obter localização...'; status.className = 'gps-status';
    navigator.geolocation.getCurrentPosition(
        function(pos) {
            document.getElementById('fLat').value = pos.coords.latitude;
            document.getElementById('fLng').value = pos.coords.longitude;
            status.textContent = '✅ Localização obtida!'; status.className = 'gps-status ok';
        },
        function(err) {
            var msg = err.code===1 ? 'Permissão negada.' : err.code===2 ? 'Localização indisponível.' : 'Tempo esgotado.';
            status.textContent = '⚠️ ' + msg;
        },
        {timeout:10000, enableHighAccuracy:true}
    );
}

// ── SUBMETER ──────────────────────────────────────────
function submeter() {
    var nome = document.getElementById('fNome').value.trim();
    var tel  = document.getElementById('fTel').value.trim();
    var zona = document.getElementById('fZona').value;
    if (!nome)     { alert('Por favor indica o teu nome.'); return; }
    if (!tel)      { alert('Por favor indica o telefone.'); return; }
    if (!zona)     { alert('Por favor selecciona a zona.'); return; }
    if (!metodoPag){ alert('Por favor selecciona o método de pagamento.'); return; }
    if (Object.keys(cart).length === 0) { alert('O carrinho está vazio.'); return; }
    if ((metodoPag === 'mpesa' || metodoPag === 'emola') &&
        (!document.getElementById('fComp').files || document.getElementById('fComp').files.length === 0)) {
        alert('Por favor anexa o comprovativo de pagamento.'); return;
    }

    var itens    = Object.values(cart);
    var subtotal = 0;
    for (var i = 0; i < itens.length; i++) subtotal += itens[i].preco * itens[i].qty;

    document.getElementById('hNome').value   = nome;
    document.getElementById('hTel').value    = tel;
    document.getElementById('hZona').value   = zona;
    document.getElementById('hMorada').value = document.getElementById('fMorada').value;
    document.getElementById('hLat').value    = document.getElementById('fLat').value;
    document.getElementById('hLng').value    = document.getElementById('fLng').value;
    document.getElementById('hItens').value  = JSON.stringify(itens);
    document.getElementById('hTotal').value  = (subtotal + taxa).toFixed(2);
    document.getElementById('hObs').value    = document.getElementById('fObs').value;
    document.getElementById('hMetodo').value = metodoPag;

    // mover ficheiro comprovativo para o form antes de submeter
    var fComp = document.getElementById('fComp');
    if (fComp && fComp.files.length > 0) {
        var dt = new DataTransfer();
        dt.items.add(fComp.files[0]);
        document.querySelector('form#fForm input[name="comprovativo"]').files = dt.files;
    }

    document.getElementById('fForm').submit();
}

function fmtMzn(val) {
    return val.toLocaleString('pt-MZ', {minimumFractionDigits:2, maximumFractionDigits:2}) + ' MZN';
}
</script>
</body>
</html>
