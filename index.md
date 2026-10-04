---
layout: home

hero:
  name: "pUNC"
  text: "Polytoria Unified Naming Convention"
  tagline: "A unified naming convention for Polytoria script executors."
  image:
    src: /pUNC.svg
    alt: pUNC Logo
  actions:
    - theme: brand
      text: Explore API Reference
      link: /docs/system
    - theme: alt
      text: View on Github
      link: "https://github.com/PolyQuaternion/pUNC"
    - theme: alt
      text: Join the Discord
      link: "https://discord.gg/NEhkQy2TuK"

features:
  - title: 13 Core Modules
    details: Complete coverage across Instances, Environment, Closures, Debug, Scripts, and more.
  - title: 80+ Standardized Functions
    details: Standardized Luau globals and APIs ensuring compatibility and developer productivity.
  - title: Built-in Compliance Suite
    details: Integrated test suite to validate executor compliance directly.
---

## pUNC - Polytoria Unified Naming Convention

The **Polytoria Unified Naming Convention (pUNC)** is a standardized API specification and execution environment standard designed for the Polytoria Luau executor ecosystem. 

pUNC unifies naming conventions, behaviors, and function signatures across executor implementations, allowing developers to write consistent, cross-compatible scripts without targeting executor-specific quirks.

pUNC was created with a bare-minimum philosophy, on purpose. No excessive aliases, and no functions which do the same as others (e.g. `iscclosure` vs `islclosure`). It's easier if everyone learns a single base function, instead of three different methods for the same thing. At the time of writing, executors are still in the early stages of development, so it's still feasible and _very important_ to keep the API simple and consistent.

If your executor implements `loadstring` and `httpget`, it's already compliant with pUNC! You can use our special badge to show off on your executor:

<p align="center">
  <img src="/pUNC-badge.svg" width="256" height="256" alt="pUNC Badge" />
</p>

## pUNC Check

pUNC includes a test suite which contains a test for each function validating environment correctness, type fidelity, round-trip transformations, and error handling.

To run the test suite within your executor:

```lua
loadstring(httpget("https://raw.githubusercontent.com/PolyQuaternion/pUNC/refs/heads/main/pUNCCheck.lua"))()
```
