export default function TipPage() {
  return (
    <main style={{ minHeight: "100vh", background: "#060504", display: "flex", alignItems: "center", justifyContent: "center", padding: "40px 24px", fontFamily: "system-ui, sans-serif" }}>
      <div style={{ maxWidth: "560px", width: "100%", textAlign: "center" }}>
        <p style={{ fontSize: "4rem", margin: "0 0 16px" }}>♻️</p>
        <p style={{ color: "#D4AF37", fontSize: "0.72rem", fontWeight: 800, letterSpacing: "0.2em", textTransform: "uppercase", margin: "0 0 12px" }}>LEAVE A BLESSING</p>
        <h1 style={{ color: "#efe6d4", fontSize: "clamp(2rem, 5vw, 3rem)", fontWeight: 800, margin: "0 0 16px", lineHeight: 1.2 }}>TIP$</h1>
        <p style={{ color: "#9a8d78", lineHeight: 1.7, marginBottom: "40px", fontSize: "1rem" }}>
          This research journal is a gift to you.<br />
          If it blessed you — leave a blessing.
        </p>
        <a
          href="https://bodhibets.gumroad.com/l/TIPS"
          target="_blank"
          rel="noopener noreferrer"
          style={{ textDecoration: "none" }}
        >
          <button style={{
            width: "100%",
            maxWidth: "360px",
            padding: "18px 24px",
            background: "linear-gradient(135deg, #5a3820, #a06a38)",
            border: "1px solid rgba(200,160,90,0.4)",
            color: "#f4e6c8",
            fontWeight: 800,
            letterSpacing: "0.15em",
            fontSize: "1rem",
            cursor: "pointer",
            borderRadius: "8px",
            textTransform: "uppercase",
          }}>
            ♻️ Send a Blessing
          </button>
        </a>
        <div style={{ marginTop: "48px" }}>
          <a href="/" style={{ color: "#D4AF37", fontSize: "0.85rem", fontWeight: 700, letterSpacing: "0.1em" }}>← Back to Bodhi Bets</a>
        </div>
      </div>
    </main>
  );
}
