;; Blocks World with 8 blocks -- session 8 lab, task 3
;;   initial: two towers, a b c d (a on the table) and e f g h
;;   goal:    one tower  h d g c f b e a  (h on the table, a on top)
(define (problem blocks-8)
  (:domain blocksworld)
  (:objects a b c d e f g h - block)
  (:init (handempty)
         (ontable a) (on b a) (on c b) (on d c) (clear d)
         (ontable e) (on f e) (on g f) (on h g) (clear h))
  (:goal (and (on a e) (on e b) (on b f) (on f c) (on c g) (on g d) (on d h))))