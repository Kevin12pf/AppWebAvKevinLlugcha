/* ============================================================
   PoliMusic · Reproductor de audio
   ============================================================ */

(function () {
    "use strict";

    function playSong(url, title) {
        var audio = document.getElementById("audioPlayer");
        var label = document.getElementById("nowPlaying");

        if (!audio) {
            return;
        }

        if (label && title) {
            label.textContent = title;
        }

        audio.src = url;
        audio.load();

        var playPromise = audio.play();
        if (playPromise && typeof playPromise.catch === "function") {
            playPromise.catch(function () {
                if (label) {
                    label.textContent = title + " (pulsa play en el reproductor)";
                }
            });
        }
    }

    // Expone la función para los scripts generados por el code-behind.
    window.playSong = playSong;

    document.addEventListener("DOMContentLoaded", function () {
        var audio = document.getElementById("audioPlayer");
        if (audio) {
            audio.volume = 0.85;
        }
    });
})();
