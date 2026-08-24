(function () {
  function tick() {
    var el = document.getElementById("clock");
    if (!el) return;
    el.textContent = new Date().toLocaleString(undefined, {
      weekday: "short",
      hour: "2-digit",
      minute: "2-digit",
      second: "2-digit",
    });
  }
  tick();
  setInterval(tick, 1000);

  var host = location.hostname || "";
  var pill = document.getElementById("host-pill");
  if (pill) {
    if (host === "192.168.20.111" || host.indexOf("fam-media") !== -1) {
      pill.textContent = "fam-media console";
    } else if (host === "192.168.20.100" || host === "um690" || host === "localhost" || host === "127.0.0.1") {
      pill.textContent = "um690 platform";
    } else if (host) {
      pill.textContent = host;
    }
  }
})();
