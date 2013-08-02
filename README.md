# Alchemist

A bi-directional Ruby DSL for casting objects using a functional DSL

TODOs

- Tests for transpose
- Split assign/pass?
- Traits
  - Common trait to help de-duplicate traits that vary only slightly between each other
  - Warnings for overriding existing procs, to prevent redefining result calls and such


FUTURE

- Ability to access specific procs in the recipe by sane naming
  - Allow for more fine-grained unit testing
- Lazy loading based on rigid filename pattern
  - Removes omnipresent hash in memory from boot
  - Allows recipes not in use to be GCed
  - Would need config definition for recipes directory
    - Convenience of Railtie defining app/recipes/ automatically
