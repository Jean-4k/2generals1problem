(defparameter verbeux? t)

(defclass général ()
  ((nom :initarg :nom
	:initform (error "Veuillez spécifier un nom de général.")
	:accessor nom)
   (nb-envoyés :initarg :nb-envoyés
	       :initform 0
	       :accessor nb-envoyés)
   (nb-reçus :initarg :nb-reçus
	     :initform 0
	     :accessor nb-reçus)
   (heure-attaque :initarg :heure-attaque
		  :initform nil
		  :accessor heure-attaque)))

(defun créer-général (nom)
  (make-instance 'général :nom nom))

(defun réinitialiser-général (général &key (sauf-nb-envoyés nil))
  (unless sauf-nb-envoyés
    (setf (nb-envoyés général) 0))
  (setf (nb-reçus général) 0)
  (setf (heure-attaque général) nil))

(defun envoi-réussi? ()
  (= (random 2) 1))

(defun message-succès-réception (général)
  (when verbeux?
    (format t
	    "Le général ~a a reçu un message, total:~a.~%"
	    (nom général) (nb-reçus général))))

(defun message-échec-envoi (général1 général2)
  (when verbeux?
    (format t
	    "Le message de ~a vers ~a a échoué.~%"
	    (nom général1) (nom général2))))

(defun message-succès-envoi (général)
  (when verbeux?
    (format t
	    "Message envoyé par le général ~a.~%" (nom général))))

(defun message-échec-confirmation (général)
  (when verbeux?
    (format t
	    "Le message de confirmation envoyé par le général ~a a échoué...On recommence.~%"
	    (nom général))))

(defgeneric envoyer (général1 général2))
(defmethod envoyer ((général1 général) (général2 général))
  ;; Le général 1 a bien envoyé un message.
  (when (string= (nom général1) "A")
    (incf (nb-envoyés général1)))
  (message-succès-envoi général1)
  (if (envoi-réussi?)
      (progn
	;; Le général 2 a bien reçu un message.
	(incf (nb-reçus général2))
	(message-succès-réception général2)
	;; Le général 2 récupère l'heure d'attaque.
	(setf (heure-attaque général2) "15h00")
	(when (< (nb-reçus général2) 2)
	  ;; Le général 2 a bien envoyé un message.
	  (when (string= (nom général2) "B")
	    (incf (nb-envoyés général2)))
	  (envoyer général2 général1)))
    (progn
      (message-échec-envoi général1 général2)
      (if (string= (nom général1) "A")
	  (envoyer général1 général2)
	(progn
	  (réinitialiser-général général1 :sauf-nb-envoyés t)
	  (réinitialiser-général général2 :sauf-nb-envoyés t)
	  (message-échec-confirmation général1)
	  (envoyer général2 général1))))))

(defun tester-discussion (général1 général2 &key (verbeux? t))
  (envoyer général1 général2)
  (when verbeux?
    (format t
	    "     Heure attaque de ~a (~a envois): ~a.~%     Heure attaque de ~a (~a envois): ~a.~%~%"
	    (nom général1) (nb-envoyés général1) (heure-attaque général1)
	    (nom général2) (nb-envoyés général2) (heure-attaque général2)))
  (and
   (string= (heure-attaque général1) "15h00")
   (string= (heure-attaque général2) "15h00")))

(defun tester* (n &key (verbeux? nil))
  (unless (>= n 1)
    (error "Veuillez indiquer un nombre de tests >= 1."))
  (let ((A (créer-général "A"))
	(B (créer-général "B")))
    (if (reduce #'(lambda (x y)
		    (and x y))
		(loop for i from 1 to n collect
		      (let ((résultat (tester-discussion A B :verbeux? verbeux?)))
			(réinitialiser-général A)
			(réinitialiser-général B)
			résultat)))
	(format t "Tests valides : ~a/~a.~%" n n)
      (format t "L'un des tests a échoué.~%"))))

(defun tester (n &key (verbeux? nil))
  (time (tester* n :verbeux? verbeux?)))
