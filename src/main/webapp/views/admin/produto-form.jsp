<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <title>${empty produto.id || produto.id == 0 ? 'Novo' : 'Editar'} Produto — Muianga's</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .preview-img {
            width: 100%;
            max-height: 200px;
            object-fit: cover;
            border-radius: 8px;
            border: 2px solid var(--border);
            margin-top: 0.5rem;
            display: block;
        }
        .upload-area {
            border: 2px dashed var(--accent);
            border-radius: 8px;
            padding: 1.5rem;
            text-align: center;
            cursor: pointer;
            transition: all 0.2s;
            background: var(--bg-secondary);
        }
        .upload-area:hover { border-color: var(--gold); background: rgba(255,215,0,0.05); }
        .upload-area input[type="file"] { display: none; }
        .upload-area label { cursor: pointer; color: var(--text-muted); font-size: 0.9rem; }
        .upload-area .icon { font-size: 2rem; display: block; margin-bottom: 0.5rem; }
    </style>
</head>
<body>
<%@ include file="sidebar.jspf" %>

<div class="page-header">
    <div>
        <h1 class="page-title">${empty produto.id || produto.id == 0 ? 'Novo Produto' : 'Editar Produto'}</h1>
    </div>
    <a href="${pageContext.request.contextPath}/admin/produtos" class="btn btn-outline">← Voltar</a>
</div>

<c:if test="${not empty erro}">
    <div class="alert alert-danger"><c:out value="${erro}"/></div>
</c:if>

<div style="max-width:650px;">
<div class="card">
<form method="post" action="${pageContext.request.contextPath}/admin/produtos" enctype="multipart/form-data">
    <input type="hidden" name="id" value="${produto.id}">

    <div class="form-group">
        <label class="form-label">Nome *</label>
        <input type="text" name="nome" class="form-control" value="<c:out value='${produto.nome}'/>" required>
    </div>

    <div class="form-group">
        <label class="form-label">Descrição</label>
        <textarea name="descricao" class="form-control"><c:out value="${produto.descricao}"/></textarea>
    </div>

    <div class="grid-2">
        <div class="form-group">
            <label class="form-label">Preço (MZN) *</label>
            <input type="number" name="preco" class="form-control" step="0.01" min="0"
                   value="${produto.preco}" required>
        </div>
        <div class="form-group">
            <label class="form-label">Categoria *</label>
            <select name="categoriaId" class="form-control" required>
                <option value="">Seleccione</option>
                <c:forEach var="cat" items="${categorias}">
                    <option value="${cat.id}" ${cat.id == produto.categoriaId ? 'selected' : ''}>
                        <c:out value="${cat.nome}"/>
                    </option>
                </c:forEach>
            </select>
        </div>
    </div>

    <!-- Upload de imagem -->
    <div class="form-group">
        <label class="form-label">Imagem do Produto</label>
        <div class="upload-area" onclick="document.getElementById('inputImagem').click()">
            <span class="icon">📷</span>
            <label>Clica para escolher uma imagem (JPG, PNG, WEBP — máx. 5MB)</label>
            <input type="file" id="inputImagem" name="imagem"
                   accept="image/jpeg,image/png,image/webp"
                   onchange="previewImagem(this)">
        </div>

        <!-- Preview da nova imagem seleccionada -->
        <img id="previewNova" class="preview-img" style="display:none;" alt="Preview">

        <!-- Imagem actual (se existir) -->
        <c:if test="${not empty produto.imagem}">
            <div class="mt-2">
                <p class="text-muted" style="font-size:0.8rem;">Imagem actual:</p>
                <img src="${pageContext.request.contextPath}/imagens_produtos/${produto.imagem}"
                     class="preview-img" alt="Imagem actual">
            </div>
        </c:if>
    </div>

    <div class="form-group flex flex-center gap-1">
        <input type="checkbox" name="disponivel" id="disponivel" ${produto.disponivel ? 'checked' : ''}>
        <label for="disponivel" class="form-label" style="margin:0;cursor:pointer;">Produto disponível no menu</label>
    </div>

    <div class="flex gap-1 mt-2">
        <button type="submit" class="btn btn-gold">Guardar</button>
        <a href="${pageContext.request.contextPath}/admin/produtos" class="btn btn-outline">Cancelar</a>
    </div>
</form>
</div>
</div>

<script>
function previewImagem(input) {
    const preview = document.getElementById('previewNova');
    if (input.files && input.files[0]) {
        const reader = new FileReader();
        reader.onload = function(e) {
            preview.src = e.target.result;
            preview.style.display = 'block';
        };
        reader.readAsDataURL(input.files[0]);
        // Actualizar o texto da área de upload
        input.previousElementSibling.textContent = '✅ ' + input.files[0].name;
    }
}
</script>

</div><%-- fecha main-content --%>
</div><%-- fecha layout --%>
</body>
</html>
