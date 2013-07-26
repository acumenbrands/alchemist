# Alchemist

A bi-directional Ruby DSL for casting objects using a functional DSL

TODOs

 - DSL method for keyword mutators
   - performed in the context of source rather than target
   - only accessible in the finder
   - defined as symbol args in finder call, given via block variable as values
   - built to facilitate use of restrictive constructor behavior
 - DSL method that accepts a list of n count of fields of source and a method on target
   - provides fields from source in block
   - uses result as argument(s) for given method on target
