<?php

declare(strict_types=1);

namespace Drupal\my_module;

use Drupal\Core\Entity\EntityTypeManagerInterface;
use Drupal\user\PermissionHandler;
use Drupal\Core\Entity\EntityDisplayRepository;
use Drupal\Core\Database\Connection;

/**
 * @todo Add class description.
 */
final class Example {

  /**
   * The user permissions service.
   *
   * @var \Drupal\user\PermissionHandler
   */
  protected PermissionHandler $userPermissions;

  /**
   * The entity display repository service.
   *
   * @var \Drupal\Core\Entity\EntityDisplayRepository
   */
  protected EntityDisplayRepository $entityDisplayRepository;

  /**
   * The database service.
   *
   * @var \Drupal\Core\Database\Connection
   */
  protected Connection $database;

  /**
   * Constructs an Example object.
   */
  public function __construct(
    private readonly EntityTypeManagerInterface $entityTypeManager,
    PermissionHandler $userPermissions,
    EntityDisplayRepository $entityDisplayRepository,
    Connection $database,
  ) {
    $this->userPermissions = $userPermissions;
    $this->entityDisplayRepository = $entityDisplayRepository;
    $this->database = $database;
  }

  /**
   * @todo Add method description.
   */
  public function doSomething(): void {
    // @todo Place your code here.
    $foo = $this->userPermissions;
    $bar = $this->entityDisplayRepository;
    $baz = $this->database;
    $a = \Drupal::getContainer();
    $b = $a->get('entity_type.manager')

  }

}
