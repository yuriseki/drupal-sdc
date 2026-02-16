<?php

declare(strict_types=1);

namespace Drupal\my_module\Controller;

use Drupal\Core\Controller\ControllerBase;

/**
 * Returns responses for My Module routes.
 */
final class MyModuleController extends ControllerBase {

  /**
   * Builds the response.
   *
   * @return array
   *   The render array.
   */
  public function __invoke(): array {
    $build = [];
    $build['content'] = [
      '#type' => 'item',
      '#markup' => $this->t('It works!'),
    ];

    return $build;
  }

}
