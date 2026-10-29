;; =====================================================================
;;  Container pre-marshalling in PDDL  --  Assignment 7, domain file
;;  Algorithms for Optimization and Planning, Roskilde University
;;
;;  THE PROBLEM (as in Assignment 5)
;;  A bay has S stacks, each at most H containers high. Every container
;;  has a group number; group 1 leaves first. A container is BLOCKING if
;;  a container of a smaller group is somewhere below it. The crane takes
;;  the top container of a stack and puts it on top of a stack that is
;;  not full. Goal: no container is blocking.
;;
;;  HOW WE MODEL IT
;;  * Every stack has a BASE object, the ground under the stack. Bases
;;    and containers are both PLACES: a container sits on a place.
;;  * The crane works in two steps, as in Blocks World: pick-up, then a
;;    put-down action. One crane move is two plan steps.
;;  * TIERS t0, t1, ..., tH give the height: a base is at tier t0, a
;;    container on top of something at tier t is at the next tier.
;;    There is no tier above tH, so nothing can be put on a full stack.
;;  * GROUPS are objects too, with a static order (leq g1 g2): "g1 does
;;    not leave later than g2". Every base belongs to the special group
;;    gtop, which is later than all real groups: anything may stand on
;;    the ground.
;;  * (well-placed ?p): p and everything below it is in order, i.e. no
;;    container in that part of the stack is blocking. Bases are always
;;    well-placed. The goal is that every container is well-placed.
;;
;;  WHAT YOU WRITE: the two put-down actions (marked TODO).
;;  Use only what Pyperplan supports: STRIPS with types, so no negative
;;  preconditions, no "or", no "forall", no conditional effects.
;; =====================================================================

(define (domain premarshalling)
  (:requirements :strips :typing)

  (:types container base - place
          place tier group)

  (:predicates
    (on ?c - container ?p - place)    ; c sits directly on p
    (clear ?p - place)                ; nothing sits on p
    (holding ?c - container)          ; the crane holds c
    (crane-free)                      ; the crane holds nothing
    (at-tier ?p - place ?t - tier)    ; p is at tier t (bases: t0)
    (next ?t1 - tier ?t2 - tier)      ; t2 is directly above t1   (static)
    (group ?p - place ?g - group)     ; p belongs to group g      (static)
    (leq ?g1 - group ?g2 - group)     ; g1 leaves no later than g2 (static)
    (well-placed ?p - place))         ; p and everything below it are in order

  ;; Given: lift container c off the place it sits on.
  ;; A lifted container is no longer well-placed (it is not in a stack).
  (:action pick-up
    :parameters (?c - container ?from - place ?t - tier)
    :precondition (and (on ?c ?from) (clear ?c) (crane-free) (at-tier ?c ?t))
    :effect (and (holding ?c) (clear ?from)
                 (not (on ?c ?from)) (not (clear ?c)) (not (crane-free))
                 (not (at-tier ?c ?t)) (not (well-placed ?c))))

  ;; TODO 1: put-down-well
  ;; Put the held container c on top of place ?to such that c is
  ;; well-placed afterwards. When is that the case? Make sure the stack
  ;; is not full, and that every fact that changes is updated.

  ;; TODO 2: put-down
  ;; Put the held container c on top of any place ?to whose stack is not
  ;; full. Afterwards c is not well-placed (unless it was put there with
  ;; put-down-well instead).
)