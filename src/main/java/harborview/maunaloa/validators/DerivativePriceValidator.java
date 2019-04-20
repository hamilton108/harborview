package harborview.maunaloa.validators;

import oahu.financial.DerivativePrice;

@FunctionalInterface
public interface DerivativePriceValidator {
    boolean validate(DerivativePrice price);
}
