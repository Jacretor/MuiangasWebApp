<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Menu Digital — Muianga's</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body { padding-top: 70px; }

        /* HERO */
        .menu-hero {
            background: linear-gradient(135deg, #120F0C 0%, #1A1410 100%);
            padding: 3rem 2rem 2rem;
            text-align: center;
            border-bottom: 1px solid #1E1814;
        }
        .menu-hero h1 {
            font-size: clamp(2rem, 5vw, 3.5rem);
            font-weight: 900;
            letter-spacing: 6px;
            color: #C8A951;
        }
        .menu-hero p {
            font-size: 0.72rem;
            letter-spacing: 4px;
            text-transform: uppercase;
            color: #4A4038;
            margin-top: 0.5rem;
        }

        /* FILTROS — sticky */
        .filtros-wrap {
            position: sticky;
            top: 68px;
            z-index: 40;
            background: rgba(14,12,10,0.97);
            backdrop-filter: blur(12px);
            border-bottom: 1px solid #1E1814;
            padding: 1rem 2rem;
        }
        .filtros-inner {
            max-width: 1100px;
            margin: 0 auto;
            display: flex;
            gap: 0.6rem;
            flex-wrap: wrap;
            align-items: center;
        }
        .filtro-btn {
            padding: 0.5rem 1.2rem;
            border-radius: 20px;
            border: 1px solid #2A2218;
            background: transparent;
            color: #5A4E44;
            font-family: 'Montserrat', sans-serif;
            font-size: 0.72rem;
            font-weight: 600;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            cursor: pointer;
            transition: all 0.2s;
        }
        .filtro-btn:hover {
            border-color: #6B4C2A;
            color: #C0B4A8;
        }
        .filtro-btn.active {
            background: #C8A951;
            border-color: #C8A951;
            color: #0E0C0A;
        }

        /* CONTADOR */
        .menu-contador {
            max-width: 1100px;
            margin: 1.5rem auto 0;
            padding: 0 2rem;
            font-size: 0.72rem;
            color: #3A3028;
            letter-spacing: 1px;
        }

        /* GRID PRODUTOS */
        .produtos-grid {
            max-width: 1100px;
            margin: 1.5rem auto 4rem;
            padding: 0 2rem;
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 1.5rem;
        }

        /* CARD PRODUTO */
        .prod-card {
            background: #161210;
            border: 1px solid #1E1814;
            border-radius: 8px;
            overflow: hidden;
            transition: all 0.3s ease;
            cursor: default;
        }
        .prod-card:hover {
            border-color: #6B4C2A;
            transform: translateY(-4px);
            box-shadow: 0 12px 30px rgba(0,0,0,0.5);
        }
        .prod-card.hidden { display: none; }

        .prod-img {
            width: 100%;
            height: 180px;
            object-fit: cover;
            display: block;
            transition: transform 0.4s ease;
        }
        .prod-card:hover .prod-img { transform: scale(1.04); }

        .prod-emoji {
            width: 100%;
            height: 180px;
            background: #1A1510;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .prod-body { padding: 1.2rem; }
        .prod-cat {
            font-size: 0.62rem;
            font-weight: 700;
            letter-spacing: 2px;
            text-transform: uppercase;
            color: #C8A951;
            margin-bottom: 0.4rem;
        }
        .prod-nome {
            font-size: 1rem;
            font-weight: 700;
            color: #F0EAE0;
            margin-bottom: 0.4rem;
        }
        .prod-desc {
            font-size: 0.78rem;
            color: #5A4E44;
            line-height: 1.5;
            margin-bottom: 0.8rem;
        }
        .prod-preco {
            font-size: 1.1rem;
            font-weight: 900;
            color: #C8A951;
        }

        /* VAZIO */
        .menu-vazio {
            max-width: 400px;
            margin: 4rem auto;
            text-align: center;
            display: none;
        }
        .menu-vazio.show { display: block; }
        .menu-vazio-icon { font-size: 3rem; margin-bottom: 1rem; }
        .menu-vazio p { color: #3A3028; font-size: 0.85rem; }

        @media (max-width: 480px) {
            .produtos-grid { grid-template-columns: 1fr; padding: 0 1rem; }
            .filtros-wrap { padding: 0.8rem 1rem; }
        }
    </style>
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar">
    <div class="navbar-brand">MUIANGA'S <span>Bar &amp; Restaurante</span></div>
    <ul class="navbar-nav">
        <li><a href="${pageContext.request.contextPath}/views/public/index.jsp">Início</a></li>
        <li><a href="${pageContext.request.contextPath}/menu" class="active">Menu</a></li>
        <li><a href="${pageContext.request.contextPath}/reserva">Reserva</a></li>
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

<!-- HERO -->
<div class="menu-hero">
    <h1>MENU DIGITAL</h1>
    <p>Preços em Meticais (MZN)</p>
</div>

<!-- FILTROS STICKY -->
<div class="filtros-wrap">
    <div class="filtros-inner">
        <button class="filtro-btn active" data-cat="todos" onclick="filtrar(this, 'todos')">
            Todos
        </button>
        <c:forEach var="cat" items="${categorias}">
            <button class="filtro-btn"
                    data-cat="${cat.id}"
                    onclick="filtrar(this, '${cat.id}')">
                <c:out value="${cat.nome}"/>
            </button>
        </c:forEach>
    </div>
</div>

<!-- CONTADOR -->
<div class="menu-contador" id="contador"></div>

<!-- GRID DE PRODUTOS -->
<div class="produtos-grid" id="grid">
    <c:forEach var="p" items="${produtos}">
        <div class="prod-card" data-cat="${p.categoriaId}">

            <c:choose>
                <c:when test="${not empty p.imagem}">
                    <img src="${pageContext.request.contextPath}/imagens_produtos/${p.imagem}"
                         alt="<c:out value='${p.nome}'/>"
                         class="prod-img">
                </c:when>
                <c:otherwise>
                    <div class="prod-emoji">
                        <svg viewBox="0 0 24 24" fill="none" stroke="#3A3028" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" width="40" height="40"><path d="M18 8h1a4 4 0 010 8h-1M2 8h16v9a4 4 0 01-4 4H6a4 4 0 01-4-4V8z"/><line x1="6" y1="1" x2="6" y2="4"/><line x1="10" y1="1" x2="10" y2="4"/><line x1="14" y1="1" x2="14" y2="4"/></svg>
                    </div>
                </c:otherwise>
            </c:choose>

            <div class="prod-body">
                <div class="prod-cat"><c:out value="${p.categoriaNome}"/></div>
                <div class="prod-nome"><c:out value="${p.nome}"/></div>
                <c:if test="${not empty p.descricao}">
                    <div class="prod-desc"><c:out value="${p.descricao}"/></div>
                </c:if>
                <div style="display:flex;align-items:center;justify-content:space-between;margin-top:0.8rem;flex-wrap:wrap;gap:0.5rem;">
                    <div class="prod-preco">
                        <fmt:formatNumber value="${p.preco}" pattern="#,##0.00"/> MZN
                    </div>
                    <c:choose>
                        <c:when test="${not empty sessionScope.cliente}">
                            <a href="${pageContext.request.contextPath}/delivery"
                               style="padding:0.4rem 1rem;border-radius:50px;border:1.5px solid #C8A951;color:#C8A951;font-size:0.62rem;font-weight:700;letter-spacing:1.5px;text-transform:uppercase;text-decoration:none;transition:all 0.2s;white-space:nowrap;">
                               Pedir
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/cliente/login?redirect=/delivery"
                               style="padding:0.4rem 1rem;border-radius:50px;border:1.5px solid #3A3028;color:#5A4E44;font-size:0.62rem;font-weight:700;letter-spacing:1.5px;text-transform:uppercase;text-decoration:none;transition:all 0.2s;white-space:nowrap;"
                               title="Faz login para pedir">
                               Pedir
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </c:forEach>
</div>

<!-- ESTADO VAZIO -->
<div class="menu-vazio" id="vazio">
    <div class="menu-vazio-icon">🍽️</div>
    <p>Nenhum produto disponível nesta categoria.</p>
</div>

<footer>
    <strong>MUIANGA'S</strong> Bar &amp; Restaurante · Chimoio, Manica, Moçambique · &copy; 2026
</footer>

<script>
    function filtrar(btn, catId) {
        // Actualizar botão activo
        document.querySelectorAll('.filtro-btn').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');

        // Filtrar cards
        const cards = document.querySelectorAll('.prod-card');
        let visiveis = 0;

        cards.forEach(card => {
            const pertence = catId === 'todos' || card.dataset.cat === catId;
            if (pertence) {
                card.classList.remove('hidden');
                // Animação de entrada
                card.style.animation = 'none';
                card.offsetHeight; // reflow
                card.style.animation = 'fadeIn 0.3s ease';
                visiveis++;
            } else {
                card.classList.add('hidden');
            }
        });

        // Actualizar contador
        const nomeCategoria = catId === 'todos' ? 'Todos os produtos' : btn.textContent.trim();
        document.getElementById('contador').textContent =
            visiveis + (visiveis === 1 ? ' produto' : ' produtos') +
            (catId !== 'todos' ? ' em ' + nomeCategoria : '');

        // Mostrar/esconder vazio
        document.getElementById('vazio').classList.toggle('show', visiveis === 0);
    }

    // Inicializar contador
    window.addEventListener('DOMContentLoaded', () => {
        const total = document.querySelectorAll('.prod-card').length;
        document.getElementById('contador').textContent = total + ' produtos';
    });
</script>

<style>
    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(8px); }
        to   { opacity: 1; transform: translateY(0); }
    }
</style>

</body>
</html>
