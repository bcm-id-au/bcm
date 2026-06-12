import { assertEquals, assertNotEquals } from "@std/assert";

Deno.test("build", async (test) => {
  await test.step({
    name: "check 'public/index.html'",
    fn: async () => {
      try {
        const publicIndexFileContents: string = await Deno.readTextFile(
          "public/index.html",
        );

        assertNotEquals(publicIndexFileContents, "");
      } catch (_) {
        assertEquals("File not found", "");
      }
    },
  });

  await test.step({
    name: "check 'public/css/bcm.min.css'",
    fn: async () => {
      try {
        const publicIndexFileContents: string = await Deno.readTextFile(
          "public/css/bcm.min.css",
        );

        assertNotEquals(publicIndexFileContents, "");
      } catch (_) {
        assertEquals("File not found", "");
      }
    },
  });

  await test.step({
    name: "check 'public/posts.json'",
    fn: async () => {
      try {
        const publicIndexFileContents: string = await Deno.readTextFile(
          "public/posts.json",
        );

        assertNotEquals(publicIndexFileContents, "");
      } catch (_) {
        assertEquals("File not found", "");
      }
    },
  });

  await test.step({
    name: "check 'public/images/brendan/profile/brendan_750.png'",
    fn: async () => {
      try {
        const publicIndexFileContents: string = await Deno.readTextFile(
          "public/images/brendan/profile/brendan_750.png",
        );

        assertNotEquals(publicIndexFileContents, "");
      } catch (_) {
        assertEquals("File not found", "");
      }
    },
  });

  await test.step({
    name: "check 'public/images/brendan/profile/brendan_150.webp'",
    fn: async () => {
      try {
        const publicIndexFileContents: string = await Deno.readTextFile(
          "public/images/brendan/profile/brendan_150.webp",
        );

        assertNotEquals(publicIndexFileContents, "");
      } catch (_) {
        assertEquals("File not found", "");
      }
    },
  });

  await test.step({
    name: "check 'public/resume.pdf'",
    fn: async () => {
      try {
        const publicIndexFileContents: string = await Deno.readTextFile(
          "public/resume.pdf",
        );

        assertNotEquals(publicIndexFileContents, "");
      } catch (_) {
        assertEquals("File not found", "");
      }
    },
  });
});
