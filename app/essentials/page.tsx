export default function Essentials() {
  const affiliates = [
    { name: "NOVIG", emoji: "🟢", desc: "No-vig betting exchange. Best odds guaranteed.", url: "https://novig.onelink.me/JHQQ/xn7zvxcw" },
    { name: "REBET", emoji: "💰", desc: "Get rebates on every single bet you place.", url: "https://rebet.appsonair.link/U-HEN-CHA-N1" },
    { name: "FLIFF", emoji: "🏆", desc: "Social sportsbook. Play for free, win real rewards.", url: "https://get.fliffapp.com/QlC3/70tnyp7k" },
    { name: "PIKKIT", emoji: "📊", desc: "Track every bet. Analyze your edge. Win smarter.", url: "https://links.pikkit.com/invite/defense99400" },
    { name: "BOVADA", emoji: "🦌", desc: "Trusted sportsbook. Proven payouts.", url: "https://www.bovada.lv/welcome/PT4YUTW/join" },
    { name: "EMBER", emoji: "🔥", desc: "Earn passive crypto income while you sleep.", url: "https://emberfund.onelink.me/ljTI/g5epzm7y?mining_referrer_id=MNGQAUT08CU" },
  ];

  return (
    <main style={{ minHeight: "100vh", background: "#060504", padding: "80px 24px", fontFamily: "system-ui, sans-serif" }}>
      <div style={{ maxWidth: "1100px", margin: "0 auto" }}>
        <p style={kicker}>BODHI TOOLBOX</p>
        <h1 style={{ color: "#efe6d4", fontSize: "clamp(2rem, 5vw, 3.5rem)", fontWeight: 800, margin: "0 0 12px" }}>Affiliate Links</h1>
        <p style={{ color: "#9a8d78", maxWidth: "520px", marginBottom: "48px", lineHeight: 1.6 }}>Tools Bodhi actually uses. Every link supports the mission. Use them — stack the blessings.</p>

        <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(300px, 1fr))", gap: "16px" }}>
          {affiliates.map((a) => (
            <a key={a.name} href={a.url} target="_blank" rel="noopener noreferrer sponsored" style={{ textDecoration: "none" }}>
              <div style={card}>
                <p style={{ fontSize: "2rem", margin: "0 0 8px" }}>{a.emoji}</p>
                <p style={kicker}>{a.name}</p>
                <p style={{ color: "#9a8d78", fontSize: "0.9rem", lineHeight: 1.55, margin: "8px 0 16px" }}>{a.desc}</p>
                <span style={{ color: "#D4AF37", fontSize: "0.8rem", fontWeight: 700, letterSpacing: "0.1em" }}>JOIN →</span>
              </div>
            </a>
          ))}
        </div>

        <div style={{ marginTop: "48px", textAlign: "center" }}>
          <a href="/" style={{ color: "#D4AF37", fontSize: "0.85rem", fontWeight: 700, letterSpacing: "0.1em" }}>← Back to Bodhi Bets</a>
        </div>
      </div>
    </main>
  );
}

const kicker: React.CSSProperties = {
  color: "#D4AF37", fontSize: "0.72rem", fontWeight: 800,
  letterSpacing: "0.2em", textTransform: "uppercase", margin: "0 0 4px",
};

const card: React.CSSProperties = {
  background: "#12100d",
  border: "1px solid rgba(212,175,55,0.2)",
  borderRadius: "16px",
  padding: "28px 24px",
  height: "100%",
  transition: "border-color 0.15s",
};
