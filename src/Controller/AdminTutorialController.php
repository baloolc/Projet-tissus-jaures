<?php

namespace App\Controller;

use App\Model\TutorialManager;

class AdminTutorialController extends AbstractController
{
    public const AUTHORIZED_MIMES = ['image/jpeg', 'image/jpg', 'image/png', 'image/webp'];
    public const MAX_FILE_SIZE = 1000000;
    public const MAX_NAME_LENGTH = 100;

    public function index(): string
    {
        if ($this->getUser() === null) {
            header('Location:/connexion');
            return "";
        }

        $tutorialManager = new TutorialManager();
        $tutorials = $tutorialManager->selectAll();
        return $this->twig->render('Admin/Tutorials/index.html.twig', ['tutorials' => $tutorials]);
    }

    public function addTutorial(): ?string
    {
        if ($this->getUser() === null) {
            header('Location:/connexion');
            return "";
        }

        $tutorial = $errors = [];

        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $tutorial = array_map('trim', $_POST);
            $imageFile = $_FILES['image'];
            $tutorialErrors = $this->tutorialValidate($tutorial);
            $imageErrors = $this->validateImage($imageFile);

            $errors = [...$tutorialErrors, ...$imageErrors];

            /** @phpstan-ignore-next-line */
            if (empty($errors)) {
                $extension = pathinfo($imageFile['name'], PATHINFO_EXTENSION);
                $imageName = uniqid('', true) . '.' . $extension;

                move_uploaded_file($imageFile['tmp_name'], UPLOAD_PATH . '/' . $imageName);

                $tutorialManager = new TutorialManager();
                $tutorial['image'] = $imageName;
                $tutorialManager->insert($tutorial);
                header('Location: /admin/tutoriels/');
            }
        }
        return $this->twig->render('Admin/Tutorials/add.html.twig', [
            'tutorial' => $tutorial,
            'errors' => $errors
        ]);
    }

    public function editTutorial($id): ?string
    {
        if ($this->getUser() === null) {
            header('Location:/connexion');
            return "";
        }

        $tutorial = $errors = [];
        $tutorialManager = new TutorialManager();
        $tutorial = $tutorialManager->selectOneById($id);

        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $tutorial = array_map('trim', $_POST);
            $tutorial['id'] = $id;
            $imageFile = $_FILES['image'];
            $tutorialErrors = $this->tutorialValidate($tutorial);
            $imageErrors = $this->validateImage($imageFile);

            $errors = [...$tutorialErrors, ...$imageErrors];

            /** @phpstan-ignore-next-line */
            if (empty($errors)) {
                $extension = pathinfo($imageFile['name'], PATHINFO_EXTENSION);
                $imageName = uniqid('', true) . '.' . $extension;

                move_uploaded_file($imageFile['tmp_name'], UPLOAD_PATH . '/' . $imageName);

                $tutorialManager = new TutorialManager();
                $tutorial['image'] = $imageName;
                $tutorialManager->update($tutorial);
                header('Location: /admin/tutoriels/');
            }
        }
        return $this->twig->render('Admin/Tutorials/edit.html.twig', [
            'tutorial' => $tutorial,
            'errors' => $errors
        ]);
    }

    private function tutorialValidate(array $tutorial): array
    {
        $tutorialErrors = [];
        if (empty($tutorial['name'])) {
            $tutorialErrors[] = 'Le champ nom est obligatoire';
        }

        if (strlen($tutorial['name']) > self::MAX_NAME_LENGTH) {
            $tutorialErrors[] = 'Le nom ne doit pas d??passer les ' . self::MAX_NAME_LENGTH . ' caract??res';
        }

        if (empty($tutorial['content'])) {
            $tutorialErrors[] = 'Le champ description est obligatoire';
        }

        return $tutorialErrors;
    }

    private function validateImage(array $files): array
    {
        $imageErrors = [];
        if ($files['error'] === UPLOAD_ERR_NO_FILE) {
            $imageErrors[] = 'Le fichier est obligatoire';
        } elseif ($files['error'] !== UPLOAD_ERR_OK) {
            $imageErrors[] = 'Probl??me de t??l??chargement du fichier';
        } else {
            if ($files['size'] > self::MAX_FILE_SIZE) {
                $imageErrors[] = 'Le fichier doit faire moins de ' . self::MAX_FILE_SIZE / 1000000 . 'Mo';
            }

            if (!in_array(mime_content_type($files['tmp_name']), self::AUTHORIZED_MIMES)) {
                $imageErrors[] = 'Le fichier doit ??tre de type ' . implode(', ', self::AUTHORIZED_MIMES);
            }
        }
        return $imageErrors;
    }

    public function deleteTutorial()
    {
        if ($this->getUser() === null) {
            header('Location:/connexion');
            return "";
        }

        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $id = trim($_POST['id']);
            $tipManager = new TutorialManager();
            $tipManager->delete((int)$id);

            header('Location:/admin/tutoriels/');
        }
    }
}
