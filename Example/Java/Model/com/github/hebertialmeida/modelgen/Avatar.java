package com.github.hebertialmeida.modelgen;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import android.net.Uri;

public final class Avatar {

    final @Nullable Uri original;
    final @Nullable Uri small;

    public Avatar(
            @Nullable Uri original,
            @Nullable Uri small
            ) {

        this.original = original;
        this.small = small;
    }

    @Nullable
    public Uri getOriginal() {
        return original;
    }

    @Nullable
    public Uri getSmall() {
        return small;
    }

}
