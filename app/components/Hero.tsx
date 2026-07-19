export default function Hero() {
  return (
    <section style={{ position: "relative", width: "100%", height: "100vh", overflow: "hidden", background: "#000" }}>
      <img
        src="/homepage.jpg"
        alt="Bodhi Bets"
        style={{ width: "100%", height: "100%", objectFit: "cover", objectPosition: "top center", display: "block" }}
      />
      <div style={{ position: "absolute", inset: 0, display: "flex", flexDirection: "column", justifyContent: "flex-end", alignItems: "center", paddingBottom: "110px", gap: "16px" }}>
        <a href="https://bodhibets.gumroad.com/l/LOCK" target="_blank" rel="noopener noreferrer" style={{ textDecoration: "none" }}>
          <button style={buttonStyle}>🔒 LOCK — Play of the Day</button>
        </a>
        <a href="https://bodhibets.gumroad.com/l/theGANGHA" target="_blank" rel="noopener noreferrer" style={{ textDecoration: "none" }}>
          <button style={buttonStyle}>🪷 THE GANGHA</button>
        </a>
        <a href="https://bodhibets.gumroad.com/l/TIPS" target="_blank" rel="noopener noreferrer" style={{ textDecoration: "none" }}>
          <button style={buttonStyle}>♻️ TIP$</button>
        </a>
      </div>
    </section>
  );
}

const buttonStyle: React.CSSProperties = {
  width: "320px",
  maxWidth: "88vw",
  height: "64px",
  borderRadius: "18px",
  border: "2px solid #D4AF37",
  background: "rgba(0,0,0,0.55)",
  backdropFilter: "blur(10px)",
  color: "#D4AF37",
  fontSize: "18px",
  fontWeight: "bold",
  cursor: "pointer",
  letterSpacing: "0.08em",
};
