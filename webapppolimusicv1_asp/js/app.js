/* ============================================================================
   PoliMusic - Interacciones de la interfaz (JavaScript del cliente)
   1) Contador de reproducciones (avisa a song_play.asp y actualiza la celda).
   2) Buscador de canciones que filtra la tabla por nombre.
   3) Confirmacion antes de eliminar una cancion (solo Admin).
   ============================================================================ */

document.addEventListener('DOMContentLoaded', function () {

    initPlayCounter();
    initSongSearch();
    initDeleteConfirm();

    /* ------------------------------------------------------------------
       1) Contador de reproducciones.
       Cada <audio> lleva el atributo data-song-id. Al iniciar la
       reproduccion se incrementa PLAYS en la base de datos y se
       refresca la celda "Reproductions" sin recargar la pagina.
    ------------------------------------------------------------------ */
    function initPlayCounter() {
        var players = document.querySelectorAll('audio[data-song-id]');

        Array.prototype.forEach.call(players, function (audio) {
            audio.addEventListener('play', function () {
                var id = audio.getAttribute('data-song-id');

                fetch('song_play.asp?id=' + encodeURIComponent(id), { method: 'POST' })
                    .then(function (response) { return response.json(); })
                    .then(function (data) {
                        if (data && data.ok && data.plays !== undefined) {
                            var cell = document.getElementById('plays-' + id);
                            if (cell) { cell.textContent = data.plays; }
                        }
                    })
                    .catch(function () { /* si falla, la reproduccion continua */ });
            });
        });
    }

    /* ------------------------------------------------------------------
       2) Buscador: filtra las filas de la tabla por nombre de cancion.
    ------------------------------------------------------------------ */
    function initSongSearch() {
        var input = document.getElementById('songSearch');
        var table = document.getElementById('songsTable');
        if (!input || !table) { return; }

        input.addEventListener('input', function () {
            var term = input.value.trim().toLowerCase();
            var rows = table.querySelectorAll('tbody tr');

            Array.prototype.forEach.call(rows, function (row) {
                var nameCell = row.querySelector('.song-name');
                if (!nameCell) { return; }
                var match = nameCell.textContent.toLowerCase().indexOf(term) !== -1;
                row.style.display = match ? '' : 'none';
            });
        });
    }

    /* ------------------------------------------------------------------
       3) Confirmacion antes de eliminar (data-confirm="mensaje").
    ------------------------------------------------------------------ */
    function initDeleteConfirm() {
        var links = document.querySelectorAll('a[data-confirm]');

        Array.prototype.forEach.call(links, function (link) {
            link.addEventListener('click', function (event) {
                if (!window.confirm(link.getAttribute('data-confirm'))) {
                    event.preventDefault();
                }
            });
        });
    }
});
