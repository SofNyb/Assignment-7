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
    (next ?t1 - tier ?t2 - tier)            ; t2 is directly above t1   (static)
    (group ?p - place ?g - group)           ; p belongs to group g      (static)
    (leq ?g1 - group ?g2 - group)           ; g1 leaves no later than g2 (static)
    (well-placed ?p - place))         ; p and everything below it are in order

  ;; Given: lift container c off the place it sits on.
  ;; A lifted container is no longer well-placed (it is not in a stack).
  (:action pick-up
    :parameters (
        ?c - container              ;; container c to be lifted
        ?from - place               ;; place from which the container c is lifted
        ?t - tier)                  ;; tier of the place ?from
    :precondition (and
        (on ?c ?from)               ;; container c is on the place ?from
        (clear ?c)               ;; the place above the container c is clear
        (crane-free)                ;; the crane is free to lift the container c
        (at-tier ?c ?t))            ;; container c is at tier ?t (the tier of the place ?from)
    :effect (and
        (holding ?c) (clear ?from)  ;; the crane is holding the container c, and the place ?from is now clear
        (not (on ?c ?from))         ;; the container c is no longer on the place ?from
        (not (clear ?c))            ;; the container c is no longer clear (it is being held by the crane)
        (not (crane-free))          ;; the crane is no longer free (it is holding the container c)
        (not (at-tier ?c ?t))       ;; the container c is no longer at tier ?t (it is being held by the crane)
        (not (well-placed ?c))))    ;; the container c is no longer well-placed (it is being held by the crane)

  ;; TODO 1: put-down-well
  ;; Put the held container c on top of place ?to such that c is
  ;; well-placed afterwards. When is that the case? Make sure the stack
  ;; is not full, and that every fact that changes is updated.

  (:action put-down-well
    :parameters (
        ?c - container          ;; container the crane holds that has to be put down
        ?to - place             ;; destination where the container has to be placed
        ?t - tier               ;; destination tier - nuværende tier
        ?t2 - tier              ;; Tier above the destination
        ?g1 - group             ;; Container group
        ?g2 - group)            ;; Destination group
    :precondition (and
        (holding ?c)            ;; Is the crane holding the container c? 
        (clear ?to)             ;; is the destination clear (nothing's on top of it)?
        (at-tier ?to ?t)        ;; At which tier is the destination located?
        (next ?t ?t2)           ;; Is there a tier diectly above the destination?
        (well-placed ?to)       ;; Is the destination already well-placed?
        (group ?c ?g1)          ;; Which group does the container c belong to?
        (group ?to ?g2)         ;; Which group does the destination belong to?
        (leq ?g1 ?g2))          ;; Can the container group g1 be placed on top of the destination group g2?
    :effect (and
        (well-placed ?c)        ;; container c is well-placed after being put down
        (crane-free)            ;; crane is free after putting down the container
        (clear ?c)              ;; nothing is on top of container c after putting it down
        (at-tier ?c ?t2)        ;; container c is at the tier directly above the destination ?t2
        (on ?c ?to)             ;; container c is placed directly on destination ?to 
        (not (holding ?c))      ;; the crane is no longer holding container c
        (not (clear ?to)))      ;; the destination ?to is no longer clear after putting down the container c
  )

  ;; TODO 2: put-down
  ;; Put the held container c on top of any place ?to whose stack is not
  ;; full. Afterwards c is not well-placed (unless it was put there with
  ;; put-down-well instead).
  (:action put-down
    :parameters (
        ?c - container          ;; container the crane holds that has to be put down
        ?to - place             ;; destination where the container has to be placed
        ?t - tier               ;; destination tier - nuværende tier
        ?t2 - tier)             ;; Tier above the destination
    :precondition (and
        (holding ?c)            ;; Is the crane holding the container c? 
        (clear ?to)             ;; is the destination clear (nothing's on top of it)?
        (at-tier ?to ?t)        ;; At which tier is the destination located?
        (next ?t ?t2))          ;; Is there a tier diectly above the destination?
    :effect (and
        (crane-free)            ;; crane is free after putting down the container
        (clear ?c)              ;; nothing is on top of container c after putting it down
        (at-tier ?c ?t2)        ;; container c is at the tier directly above the destination ?t2
        (on ?c ?to)             ;; container c is placed directly on destination ?to 
        (not (well-placed ?c))  ;; container c is not well-placed after being put down
        (not (holding ?c))      ;; the crane is no longer holding container c
        (not (clear ?to)))
  )
)