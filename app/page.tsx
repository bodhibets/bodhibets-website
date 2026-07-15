import Hero from "./components/Hero";

export default function Home() {
  return (
    <>
      <Hero />

      <section
        style={{
          minHeight: "100vh",
          background: "#000",
          color: "#D4AF37",
          padding: "60px 24px",
        }}
      >
        <h1>Temple Hill Journals</h1>

        <p>Journal #1 coming today...</p>

        <p>Journal #2</p>

        <p>Journal #3</p>

        <p>Journal #4</p>
      </section>
    </>
  );
}