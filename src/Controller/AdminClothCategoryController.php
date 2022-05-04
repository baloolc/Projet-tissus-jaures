<?php

namespace App\Controller;

use App\Model\ClothCategoryManager;

class AdminClothCategoryController extends AbstractController
{
    public const AUTHORIZED_MIMES = ['image/jpeg', 'image/jpg', 'image/png', 'image/webp'];
    public const MAX_FILE_SIZE = 1000000;

    public function index(): string
    {
        $clothCategoryList = new ClothCategoryManager();
        $clothCategories = $clothCategoryList->selectAll();

        return $this->twig->render('Admin/ClothCategory/index.html.twig', ['clothCategories' => $clothCategories]);
    }

    public function addClothCategory(): ?string
    {
        $categoryErrors = [];
        $imageErrors = [];

        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $clothCategoryList = array_map('trim', $_POST);
            $categoryErrors = $this->clothCategoryValidate($clothCategoryList);

            $imageFile = $_FILES['image'];
            $imageErrors = $this->validateImage($imageFile);

            if (empty($categoryErrors) && empty($imageErrors)) {
                $extension = pathinfo($imageFile['name'], PATHINFO_EXTENSION);
                $imageName = uniqid('', true) . '.' . $extension;

                move_uploaded_file($imageFile['tmp_name'], UPLOAD_PATH . '/' . $imageName);

                $clothCategoryManager = new ClothCategoryManager();
                $clothCategoryList['image'] = $imageName;
                $clothCategoryManager->insert($clothCategoryList);
                header('Location: /admin/categories-tissus/');
            }
        }
        return $this->twig->render('Admin/ClothCategory/add.html.twig', [
            'categoryErrors' => $categoryErrors,
            'imageErrors' => $imageErrors,
        ]);
    }

    private function clothCategoryValidate(array $clothCategories): array
    {
        $errors = [];
        if (empty($clothCategories['name'])) {
            $errors[] = 'Le champ nom est obligatoire';
        }

        $nameMaxLength = 100;
        if (strlen($clothCategories['name']) > $nameMaxLength) {
            $errors[] = 'Le nom ne doit pas dépasser les 100 caractères';
        }

        return $errors;
    }

    private function validateImage(array $files): array
    {
        $errors = [];
        if ($files['error'] === UPLOAD_ERR_NO_FILE) {
            $errors[] = 'Le fichier est obligatoire';
        } elseif ($files['error'] !== UPLOAD_ERR_OK) {
            $errors[] = 'Problème de téléchargement du fichier';
        } else {
            if ($files['size'] > self::MAX_FILE_SIZE) {
                $errors[] = 'Le fichier doit faire moins de ' . self::MAX_FILE_SIZE / 1000000 . 'Mo';
            }

            if (!in_array(mime_content_type($files['tmp_name']), self::AUTHORIZED_MIMES)) {
                $errors[] = 'Le fichier doit être de type ' . implode(', ', self::AUTHORIZED_MIMES);
            }
        }

        return $errors;
    }
}
