export default function Home() {
  return (
    <>
      {/* GANGHA TIERS */}
      <section style={sectionStyle}>
        <p style={kickerStyle}>🪷 THE GANGHA</p>
        <h2 style={h2Style}>Three Doors. One Path.</h2>
        <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(260px, 1fr))", gap: "16px", marginTop: "32px" }}>
          {[
            { name: "ROOKIE", price: "Free", link: "https://bodhibets.gumroad.com/l/theGANGHA" },
            { name: "NOVICE", price: "$33 / mo", link: "https://bodhibets.gumroad.com/l/theGANGHA" },
            { name: "NIRVANA", price: "$396 / mo", link: "https://bodhibets.gumroad.com/l/theGANGHA" },
          ].map((tier) => (
            <div key={tier.name} style={cardStyle}>
              <p style={kickerStyle}>{tier.name}</p>
              <p style={{ fontSize: "2rem", fontWeight: 800, color: "#D4AF37", margin: "8px 0 20px" }}>{tier.price}</p>
              <a href={tier.link} target="_blank" rel="noopener noreferrer">
                <button style={ctaStyle}>ENTER</button>
              </a>
            </div>
          ))}
        </div>
      </section>

      {/* AFFILIATE LINKS */}
      <section style={sectionStyle}>
        <p style={kickerStyle}>AFFILIATE LINKS</p>
        <h2 style={h2Style}>Partner Stack</h2>
        <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(140px, 1fr))", gap: "12px", marginTop: "24px" }}>
          {[
            { name: "NOVIG", url: "https://novig.onelink.me/JHQQ/xn7zvxcw" },
            { name: "REBET", url: "https://rebet.appsonair.link/U-HEN-CHA-N1" },
            { name: "FLIFF", url: "https://get.fliffapp.com/QlC3/70tnyp7k" },
            { name: "PIKKIT", url: "https://links.pikkit.com/invite/defense99400" },
            { name: "BOVADA", url: "https://www.bovada.lv/welcome/PT4YUTW/join" },
            { name: "EMBER", url: "https://emberfund.onelink.me/ljTI/g5epzm7y?mining_referrer_id=MNGQAUT08CU" },
          ].map((aff) => (
            <a key={aff.name} href={aff.url} target="_blank" rel="noopener noreferrer sponsored" style={{ textDecoration: "none" }}>
              <div style={{ ...cardStyle, textAlign: "center", padding: "24px 12px" }}>
                <p style={{ color: "#D4AF37", fontWeight: 800, letterSpacing: "0.12em", margin: 0 }}>{aff.name}</p>
              </div>
            </a>
          ))}
        </div>
      </section>

      {/* JOURNAL */}
      <section style={sectionStyle}>
        <p style={kickerStyle}>THE JOURNAL FROM TEMPLE HILL</p>
        <h2 style={h2Style}>Daily Research</h2>
        <div style={{ display: "grid", gap: "10px", marginTop: "24px" }}>
          {[
            { date: "Jul 17", title: "MLB Focus for Friday 7/17/26", url: "https://bodhibets.gumroad.com/p/mlb-focus-for-friday-7-17-26" },
            { date: "Jul 17", title: "MLB Morning Report | July 17, 2026", url: "https://bodhibets.gumroad.com/p/mlb-morning-report-july-17-2026" },
          ].map((post) => (
            <a key={post.url} href={post.url} target="_blank" rel="noopener noreferrer" style={{ textDecoration: "none" }}>
              <div style={{ ...cardStyle, display: "flex", justifyContent: "space-between", alignItems: "center" }}>
                <span style={{ color: "#D4AF37", fontSize: "0.8rem", fontWeight: 700 }}>{post.date}</span>
                <span style={{ color: "#efe6d4", fontWeight: 600, flex: 1, margin: "0 16px" }}>{post.title}</span>
                <span style={{ color: "#D4AF37", fontSize: "0.8rem", fontWeight: 700 }}>READ</span>
              </div>
            </a>
          ))}
        </div>
      </section>

      {/* TIP */}
      <section style={{ ...sectionStyle, textAlign: "center" }}>
        <p style={{ color: "#9a8d78", maxWidth: "520px", margin: "0 auto 24px", lineHeight: 1.6 }}>
          This research journal is a gift to you. If it blessed you — leave a blessing.
        </p>
        <a href="https://bodhibets.gumroad.com/l/TIPS" target="_blank" rel="noopener noreferrer">
          <button style={ctaStyle}>♻️ TIP$</button>
        </a>
      </section>

      {/* FOOTER */}
      <footer style={{ background: "#060504", borderTop: "1px solid rgba(212,175,55,0.15)", padding: "40px 24px", textAlign: "center" }}>
        <p style={{ color: "#D4AF37", fontWeight: 700, letterSpacing: "0.15em", fontSize: "0.75rem", margin: "0 0 8px" }}>EL SALVADOR | TEXAS 2026</p>
        <div style={{ display: "flex", justifyContent: "center", gap: "24px", flexWrap: "wrap", marginTop: 12 }}>
          {[
            { label: "GANGHA", url: "https://bodhibets.gumroad.com/l/theGANGHA" },
            { label: "LOCK", url: "https://bodhibets.gumroad.com/l/LOCK" },
            { label: "TIP$", url: "https://bodhibets.gumroad.com/l/TIPS" },
          ].map((l) => (
            <a key={l.label} href={l.url} target="_blank" rel="noopener noreferrer" style={{ color: "#D4AF37", fontWeight: 700, fontSize: "0.8rem", letterSpacing: "0.1em" }}>{l.label}</a>
          ))}
        </div>
        <p style={{ color: "#4a4540", fontSize: "0.72rem", marginTop: 24 }}>© 2026 Bodhi Bets. All rights reserved.</p>
      </footer>
    </>
  );
}

const sectionStyle: React.CSSProperties = {
  background: "#060504", padding: "60px 24px", maxWidth: "1100px", margin: "0 auto",
};

const cardStyle: React.CSSProperties = {
  background: "#12100d", border: "1px solid rgba(212,175,55,0.2)", borderRadius: "12px", padding: "24px",
};

const kickerStyle: React.CSSProperties = {
  color: "#D4AF37", fontSize: "0.72rem", fontWeight: 800, letterSpacing: "0.2em", textTransform: "uppercase", margin: "0 0 8px",
};

const h2Style: React.CSSProperties = {
  color: "#efe6d4", fontSize: "clamp(1.5rem, 3vw, 2rem)", fontWeight: 700, margin: "0 0 8px",
};

const ctaStyle: React.CSSProperties = {
  background: "linear-gradient(135deg, #5a3820, #a06a38)", border: "1px solid rgba(200,160,90,0.4)",
  color: "#f4e6c8", padding: "12px 32px", fontWeight: 800, letterSpacing: "0.12em",
  fontSize: "0.85rem", cursor: "pointer", borderRadius: "4px", textTransform: "uppercase",
};
