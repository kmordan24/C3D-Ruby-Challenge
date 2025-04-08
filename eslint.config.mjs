import { defineConfig, globalIgnores } from "eslint/config";
import { fixupConfigRules, fixupPluginRules } from "@eslint/compat";
import reactPlugin from "eslint-plugin-react";
import reactHooks from "eslint-plugin-react-hooks";
import prettierPlugin from "eslint-plugin-prettier";
import globals from "globals";
import babelParser from "@babel/eslint-parser";
import path from "node:path";
import { fileURLToPath } from "node:url";
import js from "@eslint/js";
import { FlatCompat } from "@eslint/eslintrc";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const compat = new FlatCompat({
    baseDirectory: __dirname,
    recommendedConfig: js.configs.recommended,
    allConfig: js.configs.all
});

export default defineConfig([
    globalIgnores(["public/", "eslint.config.mjs"]),
    {
        extends: fixupConfigRules(compat.extends(
            "eslint:recommended",
            "plugin:react/recommended",
            "plugin:react-hooks/recommended"
        )),

        plugins: {
            react: fixupPluginRules(reactPlugin),
            "react-hooks": fixupPluginRules(reactHooks),
            prettier: prettierPlugin
        },

        rules: {
            "prettier/prettier": "error"
        },

        languageOptions: {
            globals: {
                ...globals.browser,
                ...globals.node,
            },
            parser: babelParser,
            ecmaVersion: 2023,
            sourceType: "module",
        },

        settings: {
            react: {
                version: "detect"
            }
        }
    }
]);
