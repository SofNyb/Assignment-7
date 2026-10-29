;; =====================================================================
;;  Container pre-marshalling in PDDL  --  Assignment 7, problem file
;;
;;  The bay of the assignment sheet: 3 stacks, height 3, 5 containers.
;;  Stacks listed from BOTTOM to TOP, container(group):
;;
;;      stack s1:  a(1)  b(3)
;;      stack s2:  c(4)  d(2)
;;      stack s3:  e(2)
;;
;;  The objects and the static facts about tiers and groups are given.
;;  WHAT YOU WRITE: the rest of the initial state, and the goal (TODO).
;; =====================================================================

(define (problem bay1)
  (:domain premarshalling)

  (:objects
    a b c d e - container
    s1 s2 s3  - base
    t0 t1 t2 t3 - tier
    g1 g2 g3 g4 gtop - group)

  (:init
    ;; the crane is empty
    (crane-free)

    ;; tiers: height 3, so there is no tier above t3
    (next t0 t1) (next t1 t2) (next t2 t3)

    ;; the order of the groups: (leq x y) if x leaves no later than y
    (leq g1 g1) (leq g1 g2) (leq g1 g3) (leq g1 g4) (leq g1 gtop)
    (leq g2 g2) (leq g2 g3) (leq g2 g4) (leq g2 gtop)
    (leq g3 g3) (leq g3 g4) (leq g3 gtop)
    (leq g4 g4) (leq g4 gtop)
    (leq gtop gtop)

    ;; the bases: on the ground, in group gtop, always well-placed
    (at-tier s1 t0) (at-tier s2 t0) (at-tier s3 t0)
    (group s1 gtop) (group s2 gtop) (group s3 gtop)
    (well-placed s1) (well-placed s2) (well-placed s3)

    ;; TODO 3: describe the bay.
    ;;   For every container: what it sits on, its tier and its group.
    ;;   Which places are clear?  Which containers are well-placed?
  )

  ;; TODO 4: the goal
  (:goal (and
  ))
)