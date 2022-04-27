<?php

namespace App\Controller;

use App\Model\TipsManager;

class TipsController extends AbstractController
{
    public function tips(): string
    {
        $tipManager = new TipsManager();
        $tips = $tipManager->selectAll();

        return $this->twig->render('Tips/tips.html.twig', ['tips' => $tips]);
    }
}
