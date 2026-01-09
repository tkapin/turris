# Docker on OpenWRT with Extroot: Understanding `df` Output

## Setup

- **OpenWRT** with extroot on `/dev/sda1` (98 GB) mounted as `/overlay`
- **Data partition** on `/dev/sda2` (817 GB) mounted as `/srv/data`
- **Docker** configured with `data-root: /srv/data/docker` using `overlay2` storage driver

## The Confusing `df` Output

```
Filesystem           Size      Used Available Use% Mounted on
/dev/sda2           817.4G    143.6M    775.7G   0% /srv/data
/dev/sda2           817.4G    143.6M    775.7G   0% /srv/data/docker
overlay             817.4G    143.6M    775.7G   0% /srv/data/docker/overlay2/.../merged
```

### Why `/dev/sda2` Appears Twice

Docker creates a **bind mount** of its data directory for proper mount propagation:
```
/dev/sda2[/docker] → /srv/data/docker
```

This is visible in `/proc/self/mountinfo`:
```
30 26 8:2 /docker /srv/data/docker rw,relatime shared:1 - ext4 /dev/sda2 rw
```

This is **intentional Docker behavior** to ensure:
- Correct mount propagation for containers
- Overlay2 driver functions properly
- Clean namespace isolation

### Why `overlay` Shows Same Size as `/dev/sda2`

Docker's overlay2 mounts (for running containers) report the size of their **backing filesystem**, not the container layer size. This is normal.

### Why `Size ≠ Used + Available`

```
817.4 GB ≠ 143.6 MB + 775.7 GB
Missing: ~41.6 GB
```

The "missing" space is accounted for by ext4 filesystem internals:

| Component | Size | Purpose |
|-----------|------|---------|
| Reserved blocks (5%) | ~41 GB | Emergency space for root user |
| Filesystem overhead | ~14 GB | Metadata, journal, inodes |

To verify: `tune2fs -l /dev/sda2`

To recover reserved space (optional, safe for data partitions):
```bash
tune2fs -m 1 /dev/sda2   # Reduce to 1% (~8 GB reserved)
tune2fs -m 0 /dev/sda2   # Reduce to 0% (no reserved space)
```

### Why `du` Shows Different Values Than `df`

- `du -sh /srv/data` may report **higher** usage than `df`
- This is because `du` crosses into Docker's overlay mounts and counts container filesystem layers
- Use `du -sh -x /srv/data` (with `-x` flag) to stay on a single filesystem

## Conclusion

The `df` output is **correct but verbose**. The duplicate entries and apparent math discrepancies are explained by:

1. Docker's intentional bind mount for mount propagation
2. Docker overlay2 mounts showing backing filesystem size
3. ext4 reserved blocks and filesystem overhead

**No action required** — everything is working as designed.
