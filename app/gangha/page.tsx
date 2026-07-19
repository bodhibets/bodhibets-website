export default function GanghaPage() {
  const tiers = [
    { name: "ROOKIE", emoji: "🪷", price: "Free", desc: "Get in the door. Access the community and free daily research.", link: "https://bodhibets.gumroad.com/l/theGANGHA", featured: false },
    { name: "NOVICE", emoji: "🔥", price: "$33", period: "/ mo", desc: "Full access to picks, analysis, and the Bodhi Alpha signal feed.", link: "https://bodhibets.gumroad.com/l/theGANGHA", featured: true },
    { name: "NIRVANA", emoji: "✨", price: "$396", period: "/ mo", desc: "Inner circle. Direct access, priority plays, and elite positioning.", link: "https://bodhibets.gumroad.com/l/theGANGHA", featured: false },
  ];

  return (
    <main style={{ minHeight: "100vh", background: "#060504", padding: "80px 24px", fontFamily: "system-ui, sans-serif" }}>
      <div style={{ maxWidth: "1100px", margin: "0 auto" }}>
        <p style={kickerStyle}>🪷 THE GANGHA</p>
        <h1 style={{ color: "#efe6d4", fontSize: "clamp(2rem, 5vw, 3.5rem)", fontWeight: 800, margin: "0 0 12px" }}>Three Doors. One Path.</h1>
        <p style={{ color: "#9a8d78", maxWidth: "520px", marginBottom: "48px", lineHeight: 1.6 }}>Choose your level. Every door leads to the same truth — cash flow with consciousness.</p>

        <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(280px, 1fr))", gap: "20px" }}>
          {tiers.map((tier) => (
            <div key={tier.name} style={{
              background: tier.featured ? "#1a1208" : "#12100d",
              border: `1px solid ${tier.featured ? "rgba(212,175,55,0.5)" : "rgba(212,175,55,0.15)"}`,
              borderRadius: "16px",
              padding: "32px 24px",
              display: "flex",
              flexDirection: "column",
              boxShadow: tier.featured ? "0 0 40px rgba(212,175,55,0.08)" : "none",
            }}>
              {tier.featured && <p style={{ color: "#D4AF37", fontSize: "0.7rem", fontWeight: 800, letterSpacing: "0.2em", textTransform: "uppercase", margin: "0 0 16px" }}>MOST POPULAR</p>}
              <p style={{ fontSize: "2rem", margin: "0 0 4px" }}>{tier.emoji}</p>
              <p style={kickerStyle}>{tier.name}</p>
              <p style={{ color: "#D4AF37", fontSize: "2.5rem", fontWeight: 800, margin: "8px 0 4px", lineHeight: 1 }}>
                {tier.price}{tier.period && <span style={{ fontSize: "1rem", color: "#9a8d78", fontWeight: 400 }}> {tier.period}</span>}
              </p>
              <p style={{ color: "#9a8d78", fontSize: "0.9rem", lineHeight: 1.55, flex: 1, margin: "12px 0 24px" }}>{tier.desc}</p>
              <a href={tier.link} target="_blank" rel="noopener noreferrer" style={{ textDecoration: "none" }}>
                <button style={{
                  width: "100%",
                  padding: "14px",
                  background: tier.featured ? "linear-gradient(135deg, #5a3820, #a06a38)" : "transparent",
                  border: "1px solid rgba(200,160,90,0.4)",
                  color: "#f4e6c8",
                  fontWeight: 800,
                  letterSpacing: "0.12em",
                  fontSize: "0.85rem",
                  cursor: "pointer",
                  borderRadius: "8px",
                  textTransform: "uppercase",
                }}>ENTER</button>
              </a>
            </div>
          ))}
        </div>

        <div style={{ marginTop: "48px", textAlign: "center" }}>
          <a href="/" style={{ color: "#D4AF37", fontSize: "0.85rem", fontWeight: 700, letterSpacing: "0.1em" }}>← Back to Bodhi Bets</a>
        </div>
      </div>
    </main>
  );
}

const kickerStyle: React.CSSProperties = {
  color: "#D4AF37", fontSize: "0.72rem", fontWeight: 800,
  letterSpacing: "0.2em", textTransform: "uppercase", margin: "0 0 8px",
};
