export default function GanghaPage() {
  return (
    <main
      style={{
        minHeight: "100vh",
        background: "#000",
        color: "#D4AF37",
        padding: "40px 24px",
        fontFamily: "Arial, sans-serif",
      }}
    >
      <h1 style={{ fontSize: "42px", marginBottom: "10px" }}>
        Join the Gangha
      </h1>

      <p style={{ color: "#ccc", marginBottom: "40px" }}>
        Connect with Bodhi Bets across every platform.
      </p>

      <div style={{ display: "grid", gap: "18px" }}>
        <a href="#" style={cardStyle}>Instagram</a>
        <a href="#" style={cardStyle}>X</a>
        <a href="#" style={cardStyle}>TikTok</a>
        <a href="#" style={cardStyle}>YouTube</a>
      </div>

      <a
        href="/"
        style={{
          display: "inline-block",
          marginTop: "50px",
          color: "#D4AF37",
          textDecoration: "none",
          fontWeight: "bold",
        }}
      >
        ← Back to Home
      </a>
    </main>
  );
}

const cardStyle = {
  display: "block",
  padding: "20px",
  border: "2px solid #D4AF37",
  borderRadius: "16px",
  textDecoration: "none",
  color: "#D4AF37",
  background: "#111",
  fontSize: "22px",
  fontWeight: "bold" as const,
};S