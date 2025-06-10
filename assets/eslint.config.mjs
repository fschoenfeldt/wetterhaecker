import eslint from "@eslint/js";
import tseslint from "typescript-eslint";

export default [
  {
    ignores: [
      "dist/**",
      "build/**",
      "node_modules/**",
      "js/types/**",
      "eslint.config.mjs",
      "tailwind.config.js",
      "vendor/tailwindcss-animate.js",
    ],
  },
  ...tseslint.config(
    eslint.configs.recommended,
    tseslint.configs.stylisticTypeChecked,
    // https://typescript-eslint.io/getting-started/typed-linting/
    tseslint.configs.strictTypeChecked,
    {
      languageOptions: {
        parserOptions: {
          projectService: true,
          tsconfigRootDir: import.meta.dirname,
        },
      },
    }
  ),
];
