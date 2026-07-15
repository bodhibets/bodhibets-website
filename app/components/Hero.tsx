export default function Hero() {
  return (
    <section
      style={{
        position: "relative",
        width: "100%",
        height: "100vh",
        overflow: "hidden",
        background: "#000",
      }}
    >
      <img
        src="/homepage.jpg"
        alt="Bodhi Bets"
        style={{
          width: "100%",
          height: "100%",
          objectFit: "cover",
          objectPosition: "top center",
          display: "block",
        }}
      />

      <div
        style={{
          position: "absolute",
          inset: 0,
          display: "flex",
          flexDirection: "column",
          justifyContent: "flex-end",
          alignItems: "center",
          paddingBottom: "110px",
          gap: "16px",
        }}
      >
        <a href="/gangha" style={{ textDecoration: "none" }}>
          <button style={buttonStyle}>Join the Gangha</button>
        </a>

        <a href="/essentials" style={{ textDecoration: "none" }}>
          <button style={buttonStyle}>Essentials</button>
        </a>

        <a href="/tip" style={{ textDecoration: "none" }}>
          <button style={buttonStyle}>TIP$</button>
        </a>
      </div>
    </section>
  );
}

const buttonStyle = {
  width: "320px",
  maxWidth: "88%",
  height: "64px",

  borderRadius: "18px",

  border: "2px solid #D4AF37",

  background: "rgba(0,0,0,.55)",

  backdropFilter: "blur(10px)",

  color: "#D4AF37",

  fontSize: "22px",

  fontWeight: "bold" as const,

  cursor: "pointer",
};